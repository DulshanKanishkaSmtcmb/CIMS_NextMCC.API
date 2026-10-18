using CIMSNextMCC.Domain.Entities.MasterData;

namespace CIMSNextMCC.Application.Interfaces.Repositories.MasterData;

/// <summary>The values of the SP ShipperAdd / ShipperEdit (the audit user is passed separately).</summary>
public sealed record SupplierWrite(
    string ShipperCode,
    string ShipperName,
    string ShipperAddress1,
    string ShipperAddress2,
    string ShipperAddress3,
    string ShipperAddress4,
    string ShipperContact1,
    string ShipperContact2,
    string ShipperContact3,
    string ShipperCodeAir,
    string ShipperCodeSea,
    string ShipperTel,
    string ShipperEmail,
    string ShipperFax,
    string CountryCode,
    string LimaSupplierCode,
    string RexNo);

/// <summary>
/// Data access for the Supplier master page (legacy File/Supplier, table dbo.Shipper). Writes call the same stored
/// procedures with the same parameters as legacy SaveApi/SaveSupplierData and run in the request's unit-of-work transaction.
/// </summary>
public interface ISupplierRepository
{
    /// <summary>All dbo.Shipper rows ordered by ShipperCode (legacy DataApi/getSupplierList).</summary>
    Task<IReadOnlyList<SupplierMaster>> GetAllAsync(CancellationToken cancellationToken = default);

    /// <summary>The row whose ShipperCode equals <paramref name="shipperCode"/> (column collation), or null (legacy DataApi/getSupplierData).</summary>
    Task<SupplierMaster?> FindAsync(string shipperCode, CancellationToken cancellationToken = default);

    /// <summary>Rows whose ShipperName starts with (or equals) <paramref name="name"/>, ordered by ShipperName (legacy DataApi/findSupplierName).</summary>
    Task<IReadOnlyList<SupplierNameHit>> SearchByNameAsync(string name, bool startsWith, CancellationToken cancellationToken = default);

    /// <summary>
    /// The highest ShipperCode whose first character equals <paramref name="prefix"/> (legacy
    /// <c>select top 1 ShipperCode ... order by ShipperCode desc</c>), or null. Read with UPDLOCK/HOLDLOCK inside the
    /// request's transaction so two concurrent saves cannot be given the same next code.
    /// </summary>
    Task<string?> GetLastCodeAsync(string prefix, CancellationToken cancellationToken = default);

    /// <summary>SP ShipperAdd (with @CreateBy).</summary>
    Task AddAsync(SupplierWrite supplier, string createBy, CancellationToken cancellationToken = default);

    /// <summary>SP ShipperEdit (with @UpdateBy).</summary>
    Task UpdateAsync(SupplierWrite supplier, string updateBy, CancellationToken cancellationToken = default);
}
