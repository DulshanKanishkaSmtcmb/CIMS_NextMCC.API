namespace CIMSNextMCC.Domain.Entities.Security;

/// <summary>
/// The dbo.PwInfo columns the legacy login copies into its cookie (AccountController.Login / SignInUser).
/// Values are exactly as stored: UserLevel in particular is already obfuscated in the table.
/// </summary>
public class LegacyUser
{
    public string? UserName { get; set; }
    public string? UserId { get; set; }
    public string? UserCategory { get; set; }
    public string? UserLevel { get; set; }
}
