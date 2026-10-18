using CIMSNextMCC.Domain.Entities.MasterData;

namespace CIMSNextMCC.Application.Interfaces.Repositories.MasterData;

/// <summary>
/// Data access for the Packing Material (PM Master) page (legacy File/PMMaster). Writes call the same stored procedures
/// with the same parameters as legacy SaveApi/SavePMData and run in the request's unit-of-work transaction.
/// </summary>
public interface IPackingMaterialRepository
{
    /// <summary>dbo.PMMaster ordered by PMCode (legacy DataApi/getPMList).</summary>
    Task<IReadOnlyList<PackingMaterial>> GetAllAsync(CancellationToken cancellationToken = default);

    /// <summary>The row whose PMCode equals <paramref name="pmCode"/> (column collation), or null (legacy DataApi/getPMData).</summary>
    Task<PackingMaterial?> FindAsync(string pmCode, CancellationToken cancellationToken = default);

    /// <summary>dbo.PMCategories in table order (legacy DataApi/getPmCategoryData).</summary>
    Task<IReadOnlyList<PackingMaterialCategory>> GetCategoriesAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// SP PMMasterAdd @PMCode nvarchar(10), @PMDescription nvarchar(50), @PMCategory nvarchar(50), @ReorderLevel int,
    /// @PMWeight decimal(18,2), @CBM decimal(18,2), @GetJokersCount bit, @GetPartsCount bit, @IsActive bit.
    /// </summary>
    Task AddAsync(PackingMaterialValues values, CancellationToken cancellationToken = default);

    /// <summary>SP PMMasterEdit, same parameters (updates every field of the row with that PMCode except the code).</summary>
    Task UpdateAsync(PackingMaterialValues values, CancellationToken cancellationToken = default);
}

/// <summary>The nine parameters of PMMasterAdd / PMMasterEdit.</summary>
public sealed record PackingMaterialValues(
    string PmCode,
    string PmDescription,
    string PmCategory,
    int ReorderLevel,
    decimal PmWeight,
    decimal Cbm,
    bool GetJokersCount,
    bool GetPartsCount,
    bool IsActive);
