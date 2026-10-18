using CIMSNextMCC.Application.Interfaces.Repositories.Reference;
using CIMSNextMCC.Application.Reference.FieldCaptions;
using CIMSNextMCC.Domain.Entities.Reference;

namespace CIMSNextMCC.Application.Tests.Reference;

public class GetFieldCaptionsHandlerTests
{
    private sealed class FakeFieldCaptionsRepository(FldCaptions? row) : IFieldCaptionsRepository
    {
        public Task<FldCaptions?> GetAsync(CancellationToken cancellationToken = default) => Task.FromResult(row);
    }

    [Fact]
    public async Task Maps_each_caption_from_the_column_of_the_same_name()
    {
        // Distinct values per column: the legacy code crossed Item / PO / Delivery, this must not.
        var row = new FldCaptions
        {
            SysCaption = "Sys",
            ContractNoCaption = "Contract",
            ItemNoCaption = "Item",
            PONoCaption = "PO",
            DeliveryNoCaption = "Delivery"
        };
        var handler = new GetFieldCaptionsHandler(new FakeFieldCaptionsRepository(row));

        var result = await handler.HandleAsync(new GetFieldCaptionsQuery());

        Assert.True(result.IsSuccess);
        Assert.Equal(new FieldCaptionsDto("Sys", "Contract", "Item", "PO", "Delivery"), result.Data);
    }

    [Fact]
    public async Task Returns_legacy_defaults_when_the_table_is_empty()
    {
        var handler = new GetFieldCaptionsHandler(new FakeFieldCaptionsRepository(null));

        var result = await handler.HandleAsync(new GetFieldCaptionsQuery());

        Assert.True(result.IsSuccess);
        Assert.Equal(new FieldCaptionsDto(string.Empty, "ContractNo", "ItemNo", "PONo", "DeliveryNo"), result.Data);
    }

    [Fact]
    public async Task Maps_null_columns_to_empty_strings()
    {
        var handler = new GetFieldCaptionsHandler(new FakeFieldCaptionsRepository(new FldCaptions { SysCaption = "Sys" }));

        var result = await handler.HandleAsync(new GetFieldCaptionsQuery());

        Assert.Equal(new FieldCaptionsDto("Sys", string.Empty, string.Empty, string.Empty, string.Empty), result.Data);
    }
}
