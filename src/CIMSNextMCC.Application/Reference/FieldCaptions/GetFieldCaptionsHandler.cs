using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.Reference;

namespace CIMSNextMCC.Application.Reference.FieldCaptions;

/// <summary>
/// Replaces legacy DataApiController.getfldParas / clsDBUtility.strFldCaptions.
///
/// PARITY NOTE: the legacy method crosses the columns. It reads
///   capDelivery = ItemNoCaption, capItem = PONoCaption, capPoNo = DeliveryNoCaption
/// and returns [Sys, Contract, capItem, capPoNo, capDelivery], that is
/// [Sys, Contract, PONoCaption, DeliveryNoCaption, ItemNoCaption],
/// while the fallback defaults it returns for an empty table are [ "", ContractNo, ItemNo, PONo, DeliveryNo ].
/// Here every caption is mapped from the column of the same name, so a front end that consumed the legacy
/// array by position must now read named properties. If production FldCaptions rows were filled in to
/// compensate for the crossing, check the values with the business before this page is flipped.
/// </summary>
public sealed class GetFieldCaptionsHandler(IFieldCaptionsRepository repository)
{
    // Legacy fallbacks when dbo.FldCaptions has no rows.
    private const string DefaultContractNo = "ContractNo";
    private const string DefaultItemNo = "ItemNo";
    private const string DefaultPoNo = "PONo";
    private const string DefaultDeliveryNo = "DeliveryNo";

    public async Task<Result<FieldCaptionsDto>> HandleAsync(
        GetFieldCaptionsQuery query,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);

        var row = await repository.GetAsync(cancellationToken);

        var dto = row is null
            ? new FieldCaptionsDto(string.Empty, DefaultContractNo, DefaultItemNo, DefaultPoNo, DefaultDeliveryNo)
            : new FieldCaptionsDto(
                row.SysCaption ?? string.Empty,
                row.ContractNoCaption ?? string.Empty,
                row.ItemNoCaption ?? string.Empty,
                row.PONoCaption ?? string.Empty,
                row.DeliveryNoCaption ?? string.Empty);

        return Result<FieldCaptionsDto>.Success(dto);
    }
}
