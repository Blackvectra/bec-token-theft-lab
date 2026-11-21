#Requires -Version 7.2
# Pure helpers for Invoke-LabBaseline.ps1. No Graph calls here, so they can be
# unit-tested without a tenant.

Set-StrictMode -Version Latest

function Test-LabRecipient {
    <#
    .SYNOPSIS
    True when an address is in one of the allowed lab domains.
    .DESCRIPTION
    Safety guard: the baseline must never send outside the lab tenant. The
    match is on the exact domain after '@', case-insensitive, so
    'user@nextlayersec.co.evil.com' does not pass for 'nextlayersec.co'.
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)][AllowEmptyString()][string]$Address,
        [Parameter(Mandatory)][string[]]$AllowedDomains
    )
    $parts = $Address.Trim().Split('@')
    if ($parts.Count -ne 2 -or -not $parts[0] -or -not $parts[1]) { return $false }
    $domain = $parts[1].ToLowerInvariant()
    return [bool]($AllowedDomains | Where-Object { $_.ToLowerInvariant() -eq $domain })
}

function Assert-LabContext {
    <#
    .SYNOPSIS
    Throws unless the Graph context is the expected lab tenant and account.
    .DESCRIPTION
    Takes the context as a parameter (from Get-MgContext) so it is testable.
    Stops the script from ever running against a production tenant.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][AllowNull()]$Context,
        [Parameter(Mandatory)][guid]$LabTenantId,
        [Parameter(Mandatory)][string[]]$AllowedDomains
    )
    if ($null -eq $Context) { throw 'Not connected to Microsoft Graph.' }
    if ([guid]$Context.TenantId -ne $LabTenantId) {
        throw "Connected tenant $($Context.TenantId) is not the lab tenant $LabTenantId. Refusing to run."
    }
    if (-not (Test-LabRecipient -Address $Context.Account -AllowedDomains $AllowedDomains)) {
        throw "Signed-in account '$($Context.Account)' is not in an allowed lab domain. Refusing to run."
    }
}

$script:Templates = @(
    @{ Subject = 'Agenda for {0} sync'; Body = 'Hi, here are the topics for the {0} sync. Let me know if anything is missing.' }
    @{ Subject = 'Re: {0} numbers'; Body = 'Thanks, I reviewed the {0} numbers and they look right to me.' }
    @{ Subject = 'Quick question about {0}'; Body = 'Do you have a few minutes later to talk about {0}?' }
    @{ Subject = '{0} notes'; Body = 'Sharing my notes from the {0} discussion for reference.' }
)
$script:Topics = @('Q1 planning', 'vendor onboarding', 'team offsite', 'budget review', 'project kickoff', 'hiring')

function New-BaselineMessage {
    <#
    .SYNOPSIS
    Builds one benign message. Deliberately avoids the attack keywords
    (invoice, payment, wire, bank) so baseline mail does not pollute the
    inbox-rule and BEC hunting queries.
    #>
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)][string]$Recipient,
        [System.Random]$Random = [System.Random]::new()
    )
    $t = $script:Templates[$Random.Next($script:Templates.Count)]
    $topic = $script:Topics[$Random.Next($script:Topics.Count)]
    @{
        Subject   = $t.Subject -f $topic
        Body      = $t.Body -f $topic
        Recipient = $Recipient
    }
}

function ConvertTo-GraphMailBody {
    <# Shapes a message for Send-MgUserMail -BodyParameter. #>
    [CmdletBinding()]
    [OutputType([hashtable])]
    param([Parameter(Mandatory)][hashtable]$Message)
    @{
        message         = @{
            subject      = $Message.Subject
            body         = @{ contentType = 'Text'; content = $Message.Body }
            toRecipients = @(@{ emailAddress = @{ address = $Message.Recipient } })
        }
        saveToSentItems = $true
    }
}

Export-ModuleMember -Function Test-LabRecipient, Assert-LabContext, New-BaselineMessage, ConvertTo-GraphMailBody
