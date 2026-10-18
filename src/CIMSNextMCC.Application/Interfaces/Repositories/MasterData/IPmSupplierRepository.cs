using CIMSNextMCC.Domain.Entities.MasterData;

namespace CIMSNextMCC.Application.Interfaces.Repositories.MasterData;

/// <summary>The values of the SP PMSupplierAdd / PMSupplierEdit (the SPs take no audit user).</summary>
public sealed record PmSupplierWrite(
    string PmSupplierCode,
    string PmSupplierName,
    string PmSupplierAddress1,
    string PmSupplierAddress2,
    string PmSupplierAddress3,
    string PmSupplierAddress4,
    string PmSupplierContact1,
    string PmSupplierContact2,
    string PmSupplierContact3,
    string PmSupplierTel,
    string PmSupplierEmail,
    string PmSupplierFax,
    string CountryCode);

/// <summary>
/// Data access for the PM Supplier master page (legacy File/PmSupplier, table dbo.PMSupplier). Writes call the same stored
/// procedures with the same parameters as legacy SaveApi/SavePMSupplierData and run in the request's unit-of-work transaction.
/// </summary>
public interface IPmSupplierRepository
{
    /// <summary>All dbo.PMSupplier rows ordered by PMSupplierCode (legacy DataApi/getPMSupplierList).</summary>
    Task<IReadOnlyList<PmSupplierMaster>> GetAllAsync(CancellationToken cancellationToken = default);

    /// <summary>The row whose PMSupplierCode equals <paramref name="code"/> (column collation), or null (legacy DataApi/getPMSupplierData).</summary>
    Task<PmSupplierMaster?> FindAsync(string code, CancellationToken cancellationToken = default);

    /// <summary>The highest PMSupplierCode whose first character equals <paramref name="prefix"/>, or null (UPDLOCK/HOLDLOCK in the request's transaction).</summary>
    Task<string?> GetLastCodeAsync(string prefix, CancellationToken cancellationToken = default);

    /// <summary>SP PMSupplierAdd.</summary>
    Task AddAsync(PmSupplierWrite supplier, CancellationToken cancellationToken = default);

    /// <summary>SP PMSupplierEdit.</summary>
    Task UpdateAsync(PmSupplierWrite supplier, CancellationToken cancellationToken = default);
}
