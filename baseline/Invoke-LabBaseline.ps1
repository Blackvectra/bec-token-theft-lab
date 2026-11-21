#Requires -Version 7.2
#Requires -Modules Microsoft.Graph.Authentication, Microsoft.Graph.Users.Actions, Microsoft.Graph.Mail
<#
.SYNOPSIS
Generates benign baseline mail activity for one lab user.

.DESCRIPTION
Signs in as a lab user (delegated, interactive browser), sends a few benign
messages to other lab users, and reads the user's recent inbox. Run it once
per user per day during the baseline phase (PLAN.md days 4-8).

Safety guards (each throws before anything is sent):
- The Graph context must be the lab tenant given in -LabTenantId.
- The signed-in account must be in -AllowedDomains.
- Every recipient must be in -AllowedDomains.

Writes one object per action to the pipeline. Pipe it to Export-Csv to keep a
baseline log; that log is part of the ground truth for the investigation.

Delegated scopes requested: Mail.Send, Mail.Read. Uses the interactive
browser flow, not device code: device-code sign-ins are themselves a phishing
technique and would add misleading noise to the sign-in logs.

.EXAMPLE
./Invoke-LabBaseline.ps1 -LabTenantId 00000000-0000-0000-0000-000000000000 `
    -AllowedDomains nextlayersec.co -Recipients finance@nextlayersec.co,ceo@nextlayersec.co -WhatIf

.EXAMPLE
./Invoke-LabBaseline.ps1 -LabTenantId $tid -AllowedDomains nextlayersec.co `
    -Recipients finance@nextlayersec.co,helpdesk@nextlayersec.co -MessageCount 3 |
    Export-Csv ../evidence/raw/baseline-log.csv -Append -NoTypeInformation
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][guid]$LabTenantId,
    [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string[]]$AllowedDomains,
    [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string[]]$Recipients,
    [ValidateRange(1, 10)][int]$MessageCount = 3,
    [ValidateRange(0, 25)][int]$ReadCount = 5
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'BaselineHelpers.psm1') -Force

# Validate recipients before connecting, so a typo fails fast and offline.
$bad = $Recipients | Where-Object { -not (Test-LabRecipient -Address $_ -AllowedDomains $AllowedDomains) }
if ($bad) { throw "Recipients outside the allowed lab domains: $($bad -join ', ')" }

Connect-MgGraph -TenantId $LabTenantId -Scopes 'Mail.Send', 'Mail.Read' -ContextScope Process -NoWelcome
try {
    $ctx = Get-MgContext
    Assert-LabContext -Context $ctx -LabTenantId $LabTenantId -AllowedDomains $AllowedDomains
    $sender = $ctx.Account
    $targets = @($Recipients | Where-Object { $_ -ne $sender })
    if (-not $targets) { throw 'No recipients left after removing the sender.' }

    $rng = [System.Random]::new()
    for ($i = 1; $i -le $MessageCount; $i++) {
        $msg = New-BaselineMessage -Recipient $targets[$rng.Next($targets.Count)] -Random $rng
        $result = [pscustomobject]@{
            TimestampUtc = [datetime]::UtcNow.ToString('o')
            Sender       = $sender
            Action       = 'SendMail'
            Recipient    = $msg.Recipient
            Subject      = $msg.Subject
            Status       = 'Skipped'
            Error        = $null
        }
        if ($PSCmdlet.ShouldProcess($msg.Recipient, "Send '$($msg.Subject)' as $sender")) {
            try {
                Send-MgUserMail -UserId $sender -BodyParameter (ConvertTo-GraphMailBody -Message $msg)
                $result.Status = 'Sent'
            } catch {
                # Record and continue: one failed send should not hide the rest.
                $result.Status = 'Failed'
                $result.Error = $_.Exception.Message
                Write-Warning "Send to $($msg.Recipient) failed: $($result.Error)"
            }
        }
        $result
        Start-Sleep -Seconds (Get-Random -Minimum 5 -Maximum 30)
    }

    if ($ReadCount -gt 0) {
        $read = [pscustomobject]@{
            TimestampUtc = [datetime]::UtcNow.ToString('o')
            Sender       = $sender
            Action       = 'ReadInbox'
            Recipient    = $null
            Subject      = $null
            Status       = 'Skipped'
            Error        = $null
        }
        if ($PSCmdlet.ShouldProcess($sender, "Read $ReadCount inbox messages")) {
            try {
                $items = Get-MgUserMailFolderMessage -UserId $sender -MailFolderId 'Inbox' -Top $ReadCount -Property 'subject'
                $read.Status = "Read $(@($items).Count)"
            } catch {
                $read.Status = 'Failed'
                $read.Error = $_.Exception.Message
                Write-Warning "Inbox read failed: $($read.Error)"
            }
        }
        $read
    }
} finally {
    Disconnect-MgGraph | Out-Null
}
