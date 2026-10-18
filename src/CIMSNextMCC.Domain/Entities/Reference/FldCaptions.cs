namespace CIMSNextMCC.Domain.Entities.Reference;

/// <summary>One row of dbo.FldCaptions: the tenant-configurable captions for key reference fields.</summary>
public class FldCaptions
{
    public string? SysCaption { get; set; }
    public string? ContractNoCaption { get; set; }
    public string? ItemNoCaption { get; set; }
    public string? PONoCaption { get; set; }
    public string? DeliveryNoCaption { get; set; }
}
