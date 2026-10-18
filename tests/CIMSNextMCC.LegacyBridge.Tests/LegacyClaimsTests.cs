using System.Security.Claims;
using CIMSNextMCC.Domain.Entities.Security;
using CIMSNextMCC.Infrastructure.LegacyBridge;

namespace CIMSNextMCC.LegacyBridge.Tests;

/// <summary>The identity must be what AccountController.SignInUser builds: legacy code reads it by position.</summary>
public class LegacyClaimsTests
{
    internal static readonly LegacyUser SampleUser = new()
    {
        UserName = "jdoe",
        UserId = "1202xQaHZ",
        UserCategory = "Employee",
        UserLevel = "\u0090Òæ" // stored obfuscated in PwInfo; copied as is
    };

    [Fact]
    public void Claims_are_Name_Sid_GroupSid_Surname_in_that_order()
    {
        var identity = LegacyClaims.CreateIdentity(SampleUser);

        Assert.Equal(
            [ClaimTypes.Name, ClaimTypes.Sid, ClaimTypes.GroupSid, ClaimTypes.Surname],
            identity.Claims.Select(c => c.Type));
    }

    [Fact]
    public void Claim_values_use_the_legacy_encodings()
    {
        var claims = LegacyClaims.CreateIdentity(SampleUser).Claims.ToList();

        Assert.Equal("jdoe", claims[0].Value);
        Assert.Equal("1HaQx202Z", claims[1].Value);                                         // ReverseMiddle(UserId)
        Assert.Equal("ŠÚàØÞòÊÊ", claims[2].Value);  // ConvertAsc("Employee")
        Assert.Equal("\u0090Òæ", claims[3].Value);                                // UserLevel unchanged
    }

    [Fact]
    public void Legacy_decoding_by_position_gives_back_the_PwInfo_values()
    {
        // What DataApiController and NavbarController do with Claims.ElementAt(1) / ElementAt(2).
        var identity = LegacyClaims.CreateIdentity(SampleUser);

        Assert.Equal(SampleUser.UserId, LegacyClaimCodec.ReverseMiddle(identity.Claims.ElementAt(1).Value));
        Assert.Equal(SampleUser.UserCategory, LegacyClaimCodec.ReConvertAsc(identity.Claims.ElementAt(2).Value));
    }

    [Fact]
    public void Identity_matches_the_legacy_ClaimsIdentity_shape()
    {
        var identity = LegacyClaims.CreateIdentity(SampleUser);

        Assert.Equal("ApplicationCookie", identity.AuthenticationType);
        Assert.True(identity.IsAuthenticated);
        Assert.Equal(ClaimTypes.Name, identity.NameClaimType);
        Assert.Equal(ClaimTypes.Role, identity.RoleClaimType);
        Assert.Equal("jdoe", identity.Name);
        Assert.All(identity.Claims, c =>
        {
            Assert.Equal(ClaimValueTypes.String, c.ValueType);
            Assert.Equal(ClaimsIdentity.DefaultIssuer, c.Issuer);
        });
    }

    [Fact]
    public void Null_columns_become_empty_strings_like_Convert_ToString()
    {
        var identity = LegacyClaims.CreateIdentity(new LegacyUser { UserId = "AB" });

        Assert.Equal(["", "AB", "", ""], identity.Claims.Select(c => c.Value));
    }

    [Fact]
    public void Empty_UserId_fails_like_the_legacy_login() =>
        Assert.Throws<ArgumentOutOfRangeException>(() => LegacyClaims.CreateIdentity(new LegacyUser { UserName = "x" }));

    [Fact]
    public void Non_ASCII_category_fails_like_the_legacy_login() =>
        Assert.Throws<OverflowException>(() =>
            LegacyClaims.CreateIdentity(new LegacyUser { UserName = "x", UserId = "ABC", UserCategory = "Café" }));
}
