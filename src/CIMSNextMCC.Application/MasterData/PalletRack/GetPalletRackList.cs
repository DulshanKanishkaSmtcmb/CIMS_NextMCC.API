using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;

namespace CIMSNextMCC.Application.MasterData.PalletRack;

public sealed record GetPalletRackListQuery;

/// <summary>
/// Replaces legacy DataApi/getPalletRacksList (<c>select t1.* from PalletRacks t1 Order By t1.RackNo</c>) for the "Pallets
/// Area Listing" dialog. The legacy action takes the dialog's return layout (<c>strRtnPara</c>) and nothing else.
/// </summary>
public sealed class GetPalletRackListHandler(IPalletRackRepository repository)
{
    public async Task<Result<IReadOnlyList<PalletRackDto>>> HandleAsync(GetPalletRackListQuery query, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);
        var rows = await repository.GetAllAsync(cancellationToken);
        IReadOnlyList<PalletRackDto> dtos = rows.Select(r => new PalletRackDto(r.RackNo, r.NofRows, r.NofLayers, r.NofPositions)).ToList();
        return Result<IReadOnlyList<PalletRackDto>>.Success(dtos);
    }
}
