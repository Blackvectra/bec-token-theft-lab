#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0' }
BeforeAll {
    Import-Module (Join-Path $PSScriptRoot '..' 'BaselineHelpers.psm1') -Force
    $script:Allowed = @('nextlayersec.co', 'lab.onmicrosoft.com')
    $script:Tid = [guid]'11111111-1111-1111-1111-111111111111'
}

Describe 'Test-LabRecipient' {
    It 'accepts an allowed domain, case-insensitive' {
        Test-LabRecipient -Address 'Finance@NextLayerSec.CO' -AllowedDomains $Allowed | Should -BeTrue
    }
    It 'rejects an outside domain' {
        Test-LabRecipient -Address 'me@nextlayersec.io' -AllowedDomains $Allowed | Should -BeFalse
    }
    It 'rejects a suffix-spoofed domain' {
        Test-LabRecipient -Address 'x@nextlayersec.co.evil.com' -AllowedDomains $Allowed | Should -BeFalse
    }
    It 'rejects a subdomain that is not listed' {
        Test-LabRecipient -Address 'x@mail.nextlayersec.co' -AllowedDomains $Allowed | Should -BeFalse
    }
    It 'rejects malformed addresses' -ForEach @(
        @{ A = '' }, @{ A = 'noat' }, @{ A = '@nextlayersec.co' }, @{ A = 'a@b@nextlayersec.co' }
    ) {
        Test-LabRecipient -Address $A -AllowedDomains $Allowed | Should -BeFalse
    }
}

Describe 'Assert-LabContext' {
    It 'passes for the lab tenant and a lab account' {
        $ctx = [pscustomobject]@{ TenantId = $Tid.ToString(); Account = 'victim@nextlayersec.co' }
        { Assert-LabContext -Context $ctx -LabTenantId $Tid -AllowedDomains $Allowed } | Should -Not -Throw
    }
    It 'throws when not connected' {
        { Assert-LabContext -Context $null -LabTenantId $Tid -AllowedDomains $Allowed } | Should -Throw '*Not connected*'
    }
    It 'throws for a different tenant' {
        $ctx = [pscustomobject]@{ TenantId = [guid]::NewGuid().ToString(); Account = 'victim@nextlayersec.co' }
        { Assert-LabContext -Context $ctx -LabTenantId $Tid -AllowedDomains $Allowed } | Should -Throw '*not the lab tenant*'
    }
    It 'throws for an account outside the lab domains' {
        $ctx = [pscustomobject]@{ TenantId = $Tid.ToString(); Account = 'matt@nextlayersec.io' }
        { Assert-LabContext -Context $ctx -LabTenantId $Tid -AllowedDomains $Allowed } | Should -Throw '*not in an allowed lab domain*'
    }
}

Describe 'New-BaselineMessage' {
    It 'never uses BEC keywords that would pollute the hunting queries' {
        $rng = [System.Random]::new(42)
        1..200 | ForEach-Object {
            $m = New-BaselineMessage -Recipient 'ceo@nextlayersec.co' -Random $rng
            "$($m.Subject) $($m.Body)" | Should -Not -Match '(?i)invoice|payment|wire|bank'
        }
    }
    It 'is deterministic for a seeded generator' {
        $a = New-BaselineMessage -Recipient 'r@nextlayersec.co' -Random ([System.Random]::new(7))
        $b = New-BaselineMessage -Recipient 'r@nextlayersec.co' -Random ([System.Random]::new(7))
        $a.Subject | Should -Be $b.Subject
    }
}

Describe 'ConvertTo-GraphMailBody' {
    It 'produces the sendMail request shape' {
        $body = ConvertTo-GraphMailBody -Message @{ Subject = 's'; Body = 'b'; Recipient = 'r@nextlayersec.co' }
        $body.saveToSentItems | Should -BeTrue
        $body.message.toRecipients[0].emailAddress.address | Should -Be 'r@nextlayersec.co'
        $body.message.body.contentType | Should -Be 'Text'
    }
}
