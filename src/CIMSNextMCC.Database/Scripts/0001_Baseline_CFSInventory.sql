/*
    CIMSNextMCC baseline: schema of the legacy CFSInventory database (tables, indexes, constraints, stored procedures).
    Source: SSMS Generate Scripts dump of [CFSInventoryNextMCCTest], Script Date 10/18/2026 10:38:12 AM.
    Produced by tools/convert-baseline.ps1 (database-level statements, USE and excluded backup tables removed).
    Scratch backup table(s) excluded: 1 (see -ExcludeTable in the converter).
    DO NOT EDIT: it is recorded as applied on existing databases (baseline-mark). Add 0002_... scripts instead.
*/
/****** Object:  Table [dbo].[ACVStaff]    Script Date: 10/18/2026 10:38:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACVStaff](
	[StaffName] [nvarchar](100) NOT NULL,
	[IDNo] [nvarchar](20) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AlarmDevice]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlarmDevice](
	[DeviceName] [nvarchar](50) NOT NULL,
	[DeviceStatus] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BarCodeConfig]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BarCodeConfig](
	[Id] [nvarchar](10) NOT NULL,
	[TotLength] [decimal](18, 0) NOT NULL,
	[Des] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BarCodeConfigDtl]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BarCodeConfigDtl](
	[Id] [nvarchar](10) NOT NULL,
	[OrderNo] [decimal](18, 0) NOT NULL,
	[PosFrom] [decimal](18, 0) NOT NULL,
	[PosTo] [decimal](18, 0) NOT NULL,
	[Caption] [nvarchar](50) NOT NULL,
	[Matching] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BarCodeItemCategory]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BarCodeItemCategory](
	[ItemCat] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BarcodeSplit]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BarcodeSplit](
	[RcvNo] [varchar](10) NOT NULL,
	[Barcode] [varchar](40) NOT NULL,
	[EAN] [varchar](20) NOT NULL,
	[ItemSize] [varchar](40) NOT NULL,
	[ItemColor] [varchar](40) NOT NULL,
	[Qty] [decimal](18, 0) NOT NULL,
	[Ctns] [decimal](18, 0) NOT NULL,
	[SplitDeliveryId] [varchar](20) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BarcodeSplitDelivery]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BarcodeSplitDelivery](
	[SplitDeliveryId] [varchar](20) NOT NULL,
	[BookingDate] [datetime] NULL,
	[VesselOrderNo] [decimal](18, 0) NOT NULL,
	[VesselName] [varchar](50) NOT NULL,
	[VoyageNo] [varchar](20) NOT NULL,
	[Carrier] [varchar](50) NOT NULL,
	[ETD] [datetime] NULL,
	[ETA] [datetime] NULL,
	[OnBoard] [datetime] NULL,
	[CutOff] [datetime] NULL,
	[ShipMode] [varchar](10) NOT NULL,
	[ContainerOrderNo] [decimal](18, 0) NOT NULL,
	[ContainerNo] [varchar](20) NOT NULL,
	[ContainerType] [varchar](10) NOT NULL,
	[NextContainerNo] [varchar](50) NOT NULL,
	[SCMNo] [varchar](20) NOT NULL,
	[VGM] [money] NOT NULL,
	[SealNo] [varchar](25) NOT NULL,
	[GateOut] [datetime] NULL,
	[ExportType] [varchar](20) NOT NULL,
 CONSTRAINT [PK_BarcodeSplitDelivery] PRIMARY KEY CLUSTERED 
(
	[SplitDeliveryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BarcodeSplitDeliveryLastId]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BarcodeSplitDeliveryLastId](
	[SplitDeliveryNo] [decimal](18, 0) NOT NULL,
	[SplitDeliveryYear] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BlockedDCCountry]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BlockedDCCountry](
	[WhDes] [varchar](50) NOT NULL,
	[CountryCode] [varchar](10) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BookingSheetLast]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookingSheetLast](
	[BookingDate] [datetime] NULL,
	[LastNo] [decimal](18, 0) NOT NULL,
	[CreateTime] [datetime] NULL,
	[CreateBy] [nvarchar](10) NOT NULL,
	[UpdateTime] [datetime] NULL,
	[UpdateBy] [nvarchar](10) NOT NULL,
	[LastVesselNo] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BookingStatusDetails]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookingStatusDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Status] [varchar](20) NOT NULL,
	[Reason] [varchar](100) NOT NULL,
	[Date] [datetime] NOT NULL,
	[RcvNo] [varchar](10) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoBarCode]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoBarCode](
	[BarCode] [nvarchar](40) NOT NULL,
	[RcvNo] [nvarchar](10) NOT NULL,
	[ItemOption] [varchar](10) NOT NULL,
	[ILSMismatch] [varchar](5) NOT NULL,
	[Location] [nvarchar](10) NOT NULL,
	[Status] [nvarchar](10) NOT NULL,
	[QCYes] [bit] NOT NULL,
	[QCInTime] [datetime] NULL,
	[VerificationYes] [bit] NOT NULL,
	[VerificationInTime] [datetime] NULL,
	[RtnNo] [nvarchar](10) NOT NULL,
	[UpNo] [nvarchar](10) NOT NULL,
	[BarCodePcs] [decimal](18, 0) NOT NULL,
	[BarCodeGrsWgt] [money] NOT NULL,
	[BarCodeNetWgt] [money] NOT NULL,
	[UpLoadCntrNo] [nvarchar](20) NOT NULL,
	[LoadTime] [datetime] NULL,
	[PalletOrderNo] [decimal](18, 0) NOT NULL,
	[TotalPcs] [decimal](18, 0) NOT NULL,
	[PickPcs] [decimal](18, 0) NOT NULL,
	[ValidatePCS] [decimal](18, 0) NOT NULL,
	[ENA] [nvarchar](50) NOT NULL,
	[ItemSize] [nvarchar](50) NOT NULL,
	[ItemColor] [nvarchar](50) NOT NULL,
	[ItemDes] [nvarchar](100) NOT NULL,
	[CtnType] [nvarchar](10) NOT NULL,
	[CtnLength] [money] NOT NULL,
	[CtnWidth] [money] NOT NULL,
	[CtnHeight] [money] NOT NULL,
	[PickPackEnterBy] [nvarchar](10) NOT NULL,
	[PickPackEnterTime] [datetime] NULL,
	[LockPick] [bit] NOT NULL,
	[LockPickBy] [nvarchar](10) NOT NULL,
	[LockPickTime] [datetime] NULL,
	[PCSAddTime] [datetime] NULL,
	[MismatchPCS] [decimal](18, 0) NOT NULL,
	[TagMissingPCS] [decimal](18, 0) NOT NULL,
	[ValidateEnterBy] [nvarchar](10) NOT NULL,
	[ValidateEnterTime] [datetime] NULL,
	[SetItem] [bit] NOT NULL,
	[PackPCS] [decimal](18, 0) NOT NULL,
	[AddBox] [bit] NOT NULL,
	[AddBoxNo] [decimal](18, 0) NOT NULL,
	[BarcodeAudit] [nvarchar](40) NOT NULL,
	[PMStockUpdate] [nvarchar](10) NOT NULL,
	[NofParts] [decimal](18, 0) NOT NULL,
	[NofJokers] [decimal](18, 0) NOT NULL,
	[RFIDShortage] [decimal](18, 0) NOT NULL,
	[JokerTagsShortage] [decimal](18, 0) NOT NULL,
	[FirewallOK] [bit] NOT NULL,
	[LPNBoxNo] [int] NOT NULL,
	[ExportPalletNo] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoBarcodeCtnOut]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoBarcodeCtnOut](
	[RcvNo] [nvarchar](10) NOT NULL,
	[BoxId] [nvarchar](5) NOT NULL,
	[StoreCode] [nvarchar](10) NOT NULL,
	[ItemOption] [nvarchar](10) NOT NULL,
	[EAN] [nvarchar](50) NOT NULL,
	[PackQty] [decimal](18, 0) NOT NULL,
	[CtnType] [nvarchar](10) NOT NULL,
	[CtnLength] [int] NOT NULL,
	[CtnWidth] [int] NOT NULL,
	[CtnHeight] [int] NOT NULL,
	[CtnCBM] [money] NOT NULL,
	[isNewBox] [bit] NOT NULL,
	[Status] [nvarchar](10) NOT NULL,
	[LoadTime] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoBarcodeCtnOutInDtl]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoBarcodeCtnOutInDtl](
	[RcvNo] [nvarchar](10) NOT NULL,
	[BoxId] [nvarchar](5) NOT NULL,
	[BoxScanManual] [char](1) NOT NULL,
	[BarCode] [nvarchar](40) NOT NULL,
	[PackQty] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoBarcodeFirewallErrors]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoBarcodeFirewallErrors](
	[RcvNo] [nvarchar](10) NOT NULL,
	[BoxScanManual] [char](1) NOT NULL,
	[Barcode] [nvarchar](40) NOT NULL,
	[ErrorType] [char](1) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoBarcodePMUsage]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoBarcodePMUsage](
	[RcvNo] [nvarchar](10) NOT NULL,
	[BoxScanManual] [char](1) NOT NULL,
	[Barcode] [nvarchar](40) NOT NULL,
	[PMCode] [nvarchar](12) NOT NULL,
	[PMQty] [decimal](18, 0) NOT NULL,
	[EntryPoint] [nvarchar](2) NOT NULL,
	[Verified] [bit] NOT NULL,
	[UpdatedBy] [nvarchar](10) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoBarcodePMUsageContainer]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoBarcodePMUsageContainer](
	[BookingDate] [datetime] NOT NULL,
	[VesselOrderNumber] [decimal](18, 0) NOT NULL,
	[ContainerOrderNumber] [decimal](18, 0) NOT NULL,
	[PMCode] [nvarchar](12) NOT NULL,
	[PMQty] [decimal](18, 0) NOT NULL,
	[EntryPoint] [nvarchar](2) NOT NULL,
	[Verified] [bit] NOT NULL,
	[UpdatedBy] [nvarchar](10) NOT NULL,
	[IssueDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoDueFlowup]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoDueFlowup](
	[RcvNo] [varchar](10) NOT NULL,
	[DueTask] [char](1) NOT NULL,
	[DateRecord] [datetime] NULL,
	[DateFlowup] [datetime] NULL,
	[NofFlowUp] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoDueFlowUpDtl]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoDueFlowUpDtl](
	[RcvNo] [varchar](10) NOT NULL,
	[DueTask] [char](1) NOT NULL,
	[ReasonId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoDueResons]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoDueResons](
	[Id] [int] NOT NULL,
	[DueDes] [varchar](50) NOT NULL,
	[DueTask] [char](1) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoItemOption]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoItemOption](
	[RcvNo] [nvarchar](10) NOT NULL,
	[ItemOption] [nvarchar](10) NOT NULL,
	[OptionSize] [nvarchar](20) NOT NULL,
	[Ctns] [decimal](18, 0) NOT NULL,
	[PCS] [decimal](18, 0) NOT NULL,
	[ItemOptionJMB] [nvarchar](20) NOT NULL,
	[CtnType] [nvarchar](20) NOT NULL,
	[EnterDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoItemOptionRFID]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoItemOptionRFID](
	[ContractNo] [varchar](20) NOT NULL,
	[DeliveryNo] [decimal](18, 0) NOT NULL,
	[ItemOption] [varchar](10) NOT NULL,
	[OptionSize] [varchar](20) NOT NULL,
	[PCS] [decimal](18, 0) NOT NULL,
	[EnterDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoManualBox]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoManualBox](
	[RcvNo] [nvarchar](10) NOT NULL,
	[CtnNo] [decimal](18, 0) NOT NULL,
	[BarCode] [nvarchar](40) NOT NULL,
	[ItemOption] [varchar](10) NOT NULL,
	[TotalPcs] [decimal](18, 0) NOT NULL,
	[PickPcs] [decimal](18, 0) NOT NULL,
	[ENA] [nvarchar](50) NOT NULL,
	[ItemSize] [nvarchar](50) NOT NULL,
	[ItemColor] [nvarchar](50) NOT NULL,
	[ItemDes] [nvarchar](100) NOT NULL,
	[PickPackEnterBy] [nvarchar](10) NOT NULL,
	[PickPackEnterTime] [datetime] NULL,
	[PCSAddTime] [datetime] NULL,
	[MismatchPCS] [decimal](18, 0) NOT NULL,
	[TagMissingPCS] [decimal](18, 0) NOT NULL,
	[ValidatePCS] [decimal](18, 0) NOT NULL,
	[ValidateEnterBy] [nvarchar](10) NOT NULL,
	[ValidateEnterTime] [datetime] NULL,
	[SetItem] [bit] NOT NULL,
	[PackPCS] [decimal](18, 0) NOT NULL,
	[AddBox] [bit] NOT NULL,
	[AddBoxNo] [decimal](18, 0) NOT NULL,
	[NofParts] [decimal](18, 0) NOT NULL,
	[NofJokers] [decimal](18, 0) NOT NULL,
	[RFIDShortage] [decimal](18, 0) NOT NULL,
	[JokerTagsShortage] [decimal](18, 0) NOT NULL,
	[FirewallOk] [bit] NOT NULL,
	[BarcodeAudit] [varchar](40) NOT NULL,
	[LPNBoxNo] [int] NOT NULL,
	[CtnLength] [money] NOT NULL,
	[CtnWidth] [money] NOT NULL,
	[CtnHeight] [money] NOT NULL,
	[Status] [nvarchar](10) NOT NULL,
	[ExportPalletNo] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoPalletLoading]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoPalletLoading](
	[BookingDate] [datetime] NULL,
	[VesselOrderNo] [decimal](18, 0) NOT NULL,
	[ContainerOrderNo] [decimal](18, 0) NOT NULL,
	[PalletNo] [int] NOT NULL,
	[IsClosed] [bit] NOT NULL,
	[OpenDate] [datetime] NULL,
	[LastModifiedDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoPallets]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoPallets](
	[RcvNo] [nvarchar](10) NOT NULL,
	[PalletOrderNo] [decimal](18, 0) NOT NULL,
	[PalletType] [nvarchar](12) NOT NULL,
	[PalletNo] [nvarchar](50) NOT NULL,
	[UnitsLoad] [decimal](18, 0) NOT NULL,
	[PalletLocation] [nvarchar](15) NOT NULL,
	[PalletQC] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoPics]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoPics](
	[PicEvent] [nvarchar](15) NOT NULL,
	[GrnNo] [nvarchar](10) NOT NULL,
	[VesselDate] [datetime] NULL,
	[VesselOrderNo] [decimal](18, 0) NOT NULL,
	[ContainerOrderNo] [decimal](18, 0) NOT NULL,
	[BookingNo] [nvarchar](10) NOT NULL,
	[OuterBarcode] [nvarchar](50) NOT NULL,
	[PicFileName] [nvarchar](200) NOT NULL,
	[PicFileFullPath] [nvarchar](200) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoQC]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoQC](
	[RcvNo] [nvarchar](10) NOT NULL,
	[OrderNo] [decimal](18, 0) NOT NULL,
	[QCResult] [nvarchar](10) NOT NULL,
	[QCRemark] [nvarchar](50) NOT NULL,
	[QCDate] [datetime] NULL,
	[QCBy] [nvarchar](10) NOT NULL,
	[DateEnter] [datetime] NULL,
	[DateUpdate] [datetime] NULL,
	[UpdateBy] [nvarchar](10) NOT NULL,
	[QCShippingMode] [nvarchar](10) NOT NULL,
	[Final] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoRatioPack]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoRatioPack](
	[RcvNo] [varchar](10) NOT NULL,
	[BoxId] [varchar](5) NOT NULL,
	[RatioPackNo] [int] NOT NULL,
	[NofSets] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoRatioPackPlan]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoRatioPackPlan](
	[RcvNo] [varchar](10) NOT NULL,
	[RatioPackNo] [int] NOT NULL,
	[NofSets] [int] NOT NULL,
	[PcsPerSet] [int] NOT NULL,
	[NofSetsPending] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoRatioPackPlanDtl]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoRatioPackPlanDtl](
	[RcvNo] [varchar](10) NOT NULL,
	[RatioPackNo] [int] NOT NULL,
	[ItemOption] [varchar](10) NOT NULL,
	[NofOfPcs] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoReceived]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoReceived](
	[RcvNo] [nvarchar](10) NOT NULL,
	[InboundBookingType] [nvarchar](10) NOT NULL,
	[CargoFrom] [nvarchar](10) NOT NULL,
	[InboundBookingDate] [datetime] NULL,
	[InboundETD] [datetime] NULL,
	[InboundVesselOrderNo] [decimal](18, 0) NOT NULL,
	[InboundContainerOrderNo] [decimal](18, 0) NOT NULL,
	[EntryType] [nvarchar](10) NOT NULL,
	[ConfirmArriveStatus] [nvarchar](10) NOT NULL,
	[ArriveDate] [datetime] NULL,
	[ConfirmArriveTime] [datetime] NULL,
	[ConfirmArriveBy] [nvarchar](10) NOT NULL,
	[StatusCode] [varchar](10) NOT NULL,
	[BookingStatus] [nvarchar](10) NOT NULL,
	[BookingStatusBy] [nvarchar](10) NOT NULL,
	[BookingStatusTime] [datetime] NULL,
	[RcvDate] [datetime] NULL,
	[RcvTime] [datetime] NULL,
	[ShipperCode] [nvarchar](5) NOT NULL,
	[ContractNo] [nvarchar](50) NOT NULL,
	[ItemNo] [nvarchar](50) NOT NULL,
	[ItemCategory] [nvarchar](20) NOT NULL,
	[InvoiceNo] [nvarchar](50) NOT NULL,
	[PONo] [nvarchar](50) NOT NULL,
	[DeliveryNo] [decimal](18, 0) NOT NULL,
	[ShippingMode] [nvarchar](10) NOT NULL,
	[CargoType] [nvarchar](10) NOT NULL,
	[Ctns] [decimal](18, 0) NOT NULL,
	[PCS] [decimal](18, 0) NOT NULL,
	[ScanQty] [decimal](18, 0) NOT NULL,
	[CBM] [money] NOT NULL,
	[GrossWgt] [money] NOT NULL,
	[NofBar] [money] NOT NULL,
	[LorryNo] [nvarchar](50) NOT NULL,
	[IntakeComments] [nvarchar](200) NOT NULL,
	[WHLocation] [nvarchar](5) NOT NULL,
	[TradeLane] [nvarchar](20) NOT NULL,
	[Country] [nvarchar](20) NOT NULL,
	[Warehouse] [nvarchar](50) NOT NULL,
	[QCType] [nvarchar](10) NOT NULL,
	[QCYes] [nvarchar](10) NOT NULL,
	[EnterBy] [nvarchar](10) NOT NULL,
	[EnterDate] [datetime] NULL,
	[QCStatus] [nvarchar](10) NOT NULL,
	[QCDone] [bit] NOT NULL,
	[QCDoneDate] [datetime] NULL,
	[QCResult] [nvarchar](10) NOT NULL,
	[QCDoneBy] [nvarchar](10) NOT NULL,
	[QCRemarks] [nvarchar](100) NOT NULL,
	[QCDoneTimeSystem] [datetime] NULL,
	[LimaValidate] [bit] NOT NULL,
	[LimaValidateTime] [datetime] NULL,
	[Authorized] [bit] NULL,
	[AuthDate] [datetime] NULL,
	[AuthTime] [datetime] NULL,
	[DC] [nvarchar](20) NOT NULL,
	[LimaShipDate] [datetime] NULL,
	[LimaPLDate] [datetime] NULL,
	[AirCost] [nvarchar](10) NOT NULL,
	[NextToPay] [money] NOT NULL,
	[PackListUpdate] [bit] NOT NULL,
	[PackListUpdateTime] [datetime] NULL,
	[PackListUpdateBy] [nvarchar](10) NOT NULL,
	[Verification] [bit] NOT NULL,
	[VerificationDate] [datetime] NULL,
	[VerificationTime] [datetime] NULL,
	[VerificationBy] [nvarchar](10) NOT NULL,
	[RemoveStatus] [nvarchar](10) NOT NULL,
	[RemoveReference] [nvarchar](50) NOT NULL,
	[RemoveStatusDoneDate] [datetime] NULL,
	[RemoveStatusDoneBy] [nvarchar](10) NOT NULL,
	[RemoveDoneDate] [datetime] NULL,
	[RemoveDoneBy] [nvarchar](10) NOT NULL,
	[RemoveType] [nvarchar](10) NOT NULL,
	[RemovalComments] [nvarchar](200) NOT NULL,
	[ReWorkQty] [decimal](18, 0) NOT NULL,
	[InPCS] [decimal](18, 0) NOT NULL,
	[PackPCS] [decimal](18, 0) NOT NULL,
	[InQty] [decimal](18, 0) NOT NULL,
	[PackQty] [decimal](18, 0) NOT NULL,
	[RemoveQty] [decimal](18, 0) NOT NULL,
	[DeleteDate] [datetime] NULL,
	[QCStaffCode] [nvarchar](10) NOT NULL,
	[BookingDate] [datetime] NULL,
	[LoadNo] [nvarchar](10) NOT NULL,
	[VesselOrderNo] [decimal](18, 0) NOT NULL,
	[VesselPlanDate] [datetime] NULL,
	[ContainerOrderNo] [decimal](18, 0) NOT NULL,
	[LoadPosition] [decimal](18, 0) NOT NULL,
	[LimaPosition] [decimal](18, 0) NOT NULL,
	[LoadingRef] [nvarchar](10) NOT NULL,
	[LoadingRefChangeBy] [nvarchar](10) NOT NULL,
	[LoadingRefChangeTime] [datetime] NULL,
	[TailEnd] [bit] NOT NULL,
	[ShippingModeIn] [nvarchar](10) NOT NULL,
	[PCSIn] [decimal](18, 0) NOT NULL,
	[CtnsIn] [decimal](18, 0) NULL,
	[CBMIn] [money] NOT NULL,
	[DeliveryNoIn] [decimal](18, 0) NOT NULL,
	[TradeLaneIn] [nvarchar](10) NOT NULL,
	[CountryIn] [nvarchar](10) NOT NULL,
	[QCDate] [datetime] NULL,
	[RemovePartQty] [decimal](18, 0) NOT NULL,
	[RemovePartPCS] [decimal](18, 0) NOT NULL,
	[RemovePartCBM] [money] NOT NULL,
	[RemoveQtyPartScan] [decimal](18, 0) NOT NULL,
	[RemovePartDate] [datetime] NULL,
	[RemovePartBy] [nvarchar](10) NOT NULL,
	[RemovePartQtyRemark] [nvarchar](100) NOT NULL,
	[DateUpdate] [datetime] NULL,
	[UpdateBy] [nvarchar](10) NOT NULL,
	[SplitRcvNo] [nvarchar](10) NOT NULL,
	[isManualIn] [bit] NOT NULL,
	[isManualOut] [bit] NOT NULL,
	[LoadType] [nvarchar](10) NOT NULL,
	[LorryNoLoad] [nvarchar](50) NOT NULL,
	[OutTime] [datetime] NULL,
	[OutBy] [nvarchar](10) NOT NULL,
	[OldShippingMode] [nvarchar](10) NOT NULL,
	[OldAirCost] [nvarchar](10) NOT NULL,
	[ModeChangeDate] [datetime] NULL,
	[ModeChangeBy] [nvarchar](10) NOT NULL,
	[ShippingModeQC] [nvarchar](10) NOT NULL,
	[DeliveryNoQC] [decimal](18, 0) NOT NULL,
	[TradeLaneQC] [nvarchar](10) NOT NULL,
	[CountryQC] [nvarchar](10) NOT NULL,
	[QCCtns] [decimal](18, 0) NOT NULL,
	[QCPcs] [decimal](18, 0) NOT NULL,
	[QCPcsReject] [decimal](18, 0) NOT NULL,
	[Descrepancy] [nvarchar](500) NOT NULL,
	[DescrepancyOK] [bit] NOT NULL,
	[DescrepancyTime] [datetime] NULL,
	[DescrepancyBy] [nvarchar](10) NOT NULL,
	[QCQty] [decimal](18, 0) NOT NULL,
	[VerifyQty] [decimal](18, 0) NOT NULL,
	[InChecked] [bit] NOT NULL,
	[InCheckedComment] [nvarchar](100) NOT NULL,
	[InChechedTime] [datetime] NULL,
	[InCheckedBy] [nvarchar](10) NOT NULL,
	[UpLiftStatus] [nvarchar](10) NOT NULL,
	[UpLiftTime] [datetime] NULL,
	[UpLiftBy] [nvarchar](10) NOT NULL,
	[UnLoadStart] [datetime] NULL,
	[UnLoadEnd] [datetime] NULL,
	[LoadStart] [datetime] NULL,
	[LoadEnd] [datetime] NULL,
	[LoadCancelStatus] [nvarchar](20) NOT NULL,
	[LoadCancelDate] [datetime] NULL,
	[LoadCancelBy] [nvarchar](10) NOT NULL,
	[LoadCancelQty] [decimal](18, 0) NOT NULL,
	[DirectMark] [bit] NOT NULL,
	[DirectMarkBy] [nvarchar](10) NOT NULL,
	[DirectMarkTime] [datetime] NULL,
	[QCComments] [nvarchar](500) NOT NULL,
	[SubJobNo] [nvarchar](20) NOT NULL,
	[SubJobNoEnterBy] [nvarchar](10) NOT NULL,
	[SubJobNoEnterTime] [datetime] NULL,
	[QCIn] [bit] NOT NULL,
	[QCInTime] [datetime] NULL,
	[QCInBy] [nvarchar](10) NOT NULL,
	[QCInCheckBack] [bit] NOT NULL,
	[QCInCheckBackTime] [datetime] NULL,
	[QCInCheckBackBy] [nvarchar](10) NOT NULL,
	[InternalReworkRemark] [nvarchar](50) NOT NULL,
	[InternalReworkDoneTime] [datetime] NULL,
	[InternalReworkDoneBy] [nvarchar](10) NOT NULL,
	[GRNNo] [nvarchar](10) NOT NULL,
	[IntakeStatus] [nvarchar](10) NOT NULL,
	[IntakeStatusBy] [nvarchar](10) NULL,
	[IntakeTime] [datetime] NULL,
	[IntakeTimeSys] [datetime] NULL,
	[PackListYes] [nvarchar](10) NOT NULL,
	[CDNYes] [nvarchar](10) NOT NULL,
	[CusDecYes] [nvarchar](10) NOT NULL,
	[LorryContactName] [nvarchar](50) NOT NULL,
	[LorryContactNo] [nvarchar](50) NOT NULL,
	[UnloadStatus] [nvarchar](10) NOT NULL,
	[UnloadBy] [nvarchar](10) NOT NULL,
	[UnloadTimeSys] [datetime] NULL,
	[PickENADataStatus] [nvarchar](10) NOT NULL,
	[PickENADataBy] [nvarchar](10) NOT NULL,
	[PickENADataTime] [datetime] NULL,
	[PickPackQty] [decimal](18, 0) NOT NULL,
	[PickPackStatus] [nvarchar](10) NOT NULL,
	[PickPackStatusBy] [nvarchar](10) NOT NULL,
	[PickPackStatusTime] [datetime] NULL,
	[LoadingType] [nvarchar](10) NOT NULL,
	[CustomerRefNo] [nvarchar](20) NOT NULL,
	[LockUnload] [bit] NOT NULL,
	[LockUnloadBy] [nvarchar](10) NOT NULL,
	[LockUnloadTime] [datetime] NULL,
	[LockLoading] [bit] NOT NULL,
	[LockLoadingBy] [nvarchar](10) NOT NULL,
	[LoackLoadingTime] [datetime] NULL,
	[CargoQuality] [nvarchar](15) NOT NULL,
	[PickQtyAllowMismatch] [bit] NOT NULL,
	[TagMissingPCS] [decimal](18, 0) NOT NULL,
	[PickQtyAllowTagMissing] [bit] NOT NULL,
	[SizeMismatchPCS] [decimal](18, 0) NOT NULL,
	[DamageCtns] [decimal](18, 0) NOT NULL,
	[SCMNo] [nvarchar](20) NOT NULL,
	[ReachedDest] [bit] NOT NULL,
	[SCMNoRcvdTime] [datetime] NULL,
	[ApprvReqStatus] [nvarchar](10) NOT NULL,
	[ApprvReqTime] [datetime] NULL,
	[ApprvReqBy] [nvarchar](10) NOT NULL,
	[ApprvToShip] [nvarchar](20) NOT NULL,
	[ApprvToShipBy] [nvarchar](10) NOT NULL,
	[ApprvToShipTime] [datetime] NULL,
	[nApprvToShip] [nvarchar](50) NOT NULL,
	[nApprvToShipBy] [nvarchar](10) NOT NULL,
	[nApprvToShipTime] [datetime] NULL,
	[WarehouseIn] [nvarchar](50) NOT NULL,
	[nApprvToShipAction] [nvarchar](100) NOT NULL,
	[nApprvToShipActionTime] [datetime] NULL,
	[nApprvToShipActionBy] [nvarchar](10) NOT NULL,
	[ItemOptionLookup] [nvarchar](10) NOT NULL,
	[CusDecNo] [nvarchar](50) NOT NULL,
	[PCSValidationStatus] [nvarchar](10) NOT NULL,
	[PCSValidationStatusBy] [nvarchar](10) NOT NULL,
	[PCSValidationStatusTime] [datetime] NULL,
	[PCSValidateCount] [decimal](18, 0) NOT NULL,
	[ValidateQty] [decimal](18, 0) NOT NULL,
	[PackCBM] [money] NOT NULL,
	[PackWgt] [money] NOT NULL,
	[DropNo] [nvarchar](10) NOT NULL,
	[FirewallStatus] [nvarchar](10) NOT NULL,
	[FirewallStatusDoneTime] [datetime] NULL,
	[FirewallStatusBy] [nvarchar](10) NOT NULL,
	[FirewallQty] [decimal](18, 0) NOT NULL,
	[LastPackBoxNo] [decimal](18, 0) NOT NULL,
	[HoldStatus] [nvarchar](20) NOT NULL,
	[HoldReason] [nvarchar](100) NOT NULL,
	[StorePickStatus] [nvarchar](10) NOT NULL,
	[StorePickStausBy] [nvarchar](10) NOT NULL,
	[StorePickStatusTime] [datetime] NULL,
	[RfidOrder] [nvarchar](10) NOT NULL,
	[RfidOrderDate] [datetime] NULL,
	[RfidAvailableDate] [datetime] NULL,
	[HoldDate] [datetime] NULL,
	[HoldReleaseDate] [datetime] NULL,
	[TotalPlatformPartner] [varchar](30) NOT NULL,
	[SplittedCtns] [decimal](18, 0) NOT NULL,
	[DivertLocation] [varchar](25) NOT NULL,
	[DivertLocationDate] [datetime] NULL,
	[Comment] [varchar](250) NOT NULL,
	[nofParts] [int] NOT NULL,
	[NofSwingticket] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoReceivedDtl]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoReceivedDtl](
	[RcvNo] [nvarchar](10) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
	[NofCtn] [decimal](18, 0) NOT NULL,
	[NofPcs] [decimal](18, 0) NOT NULL,
	[TotGrsWgt] [money] NOT NULL,
	[TotNetWgt] [money] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoReturn]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoReturn](
	[RtnNo] [nvarchar](10) NOT NULL,
	[RtnDate] [datetime] NULL,
	[LorryNo] [nvarchar](50) NOT NULL,
	[RtnCtns] [decimal](18, 0) NOT NULL,
	[RtnTime] [datetime] NULL,
	[RcvNo] [nvarchar](10) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoStorePickPlan]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoStorePickPlan](
	[RcvNo] [nvarchar](10) NOT NULL,
	[ItemOption] [nvarchar](10) NOT NULL,
	[StoreCode] [nvarchar](10) NOT NULL,
	[PickPlanQty] [decimal](18, 0) NOT NULL,
	[PickedQty] [decimal](18, 0) NOT NULL,
	[DateEnter] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoUpload]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoUpload](
	[UpdNo] [nvarchar](10) NOT NULL,
	[UpdDate] [datetime] NULL,
	[ShipperCode] [nvarchar](10) NOT NULL,
	[LorryNo] [nvarchar](50) NOT NULL,
	[JobNo] [nvarchar](10) NOT NULL,
	[RcvNo] [nvarchar](10) NOT NULL,
	[UpdCtns] [decimal](18, 0) NOT NULL,
	[LoadRef] [nvarchar](10) NOT NULL,
	[LoadBy] [nvarchar](10) NOT NULL,
	[LoadFinish] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoUploadDtl]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoUploadDtl](
	[RcvNo] [nvarchar](10) NOT NULL,
	[ContainerOrderNo_] [decimal](18, 0) NOT NULL,
	[Row1] [decimal](18, 0) NOT NULL,
	[Row2] [decimal](18, 0) NOT NULL,
	[Row3] [decimal](18, 0) NOT NULL,
	[Row4] [decimal](18, 0) NOT NULL,
	[Row5] [decimal](18, 0) NOT NULL,
	[Row6] [decimal](18, 0) NOT NULL,
	[Row7] [decimal](18, 0) NOT NULL,
	[Row8] [decimal](18, 0) NOT NULL,
	[Row9] [decimal](18, 0) NOT NULL,
	[Row10] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoUploadLorryNo]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoUploadLorryNo](
	[UpdNo] [nvarchar](10) NOT NULL,
	[OrderNo] [decimal](18, 0) NOT NULL,
	[LorryNo] [nvarchar](50) NOT NULL,
	[LoadQty] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CargoUploadRcvNo]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CargoUploadRcvNo](
	[UpdNo] [nvarchar](10) NOT NULL,
	[RcvNo] [nvarchar](10) NOT NULL,
	[OrderNo] [decimal](18, 0) NOT NULL,
	[LoadQty] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CaroItemOptionRFID]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CaroItemOptionRFID](
	[ContractNo] [varchar](20) NOT NULL,
	[DeliveryNo] [decimal](18, 0) NOT NULL,
	[OptionSize] [varchar](20) NOT NULL,
	[Ctns] [decimal](18, 0) NOT NULL,
	[PCS] [decimal](18, 0) NOT NULL,
	[EnterDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CartonTypes]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CartonTypes](
	[CartonType] [nvarchar](10) NOT NULL,
	[CtnLength] [int] NOT NULL,
	[CtnWidth] [int] NOT NULL,
	[CtnHeight] [int] NOT NULL,
	[CtnWeight] [money] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CloudMenu]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CloudMenu](
	[MenuID] [nvarchar](20) NOT NULL,
	[MenuName] [nvarchar](100) NOT NULL,
	[MenuController] [nvarchar](100) NOT NULL,
	[MenuAction] [nvarchar](100) NOT NULL,
	[MenuArea] [nvarchar](100) NOT NULL,
	[MenuImageClass] [nvarchar](100) NOT NULL,
	[MenuActiveli] [nvarchar](100) NOT NULL,
	[MenuStatus] [bit] NOT NULL,
	[MenuIsParent] [bit] NOT NULL,
	[MenuParentID] [nvarchar](20) NOT NULL,
	[MenuIsChild1Parent] [bit] NOT NULL,
	[MenuChild1ParentID] [nvarchar](20) NOT NULL,
	[MenuIsChild2Parent] [bit] NOT NULL,
	[MenuChild2ParentID] [nvarchar](20) NOT NULL,
	[MenuActionPara] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CloudMenuAllocation]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CloudMenuAllocation](
	[UserId] [nvarchar](10) NOT NULL,
	[MenuID] [nvarchar](20) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanySetup]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanySetup](
	[RegisterNumber] [nvarchar](15) NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[Address1] [nvarchar](100) NOT NULL,
	[Address2] [nvarchar](100) NOT NULL,
	[Address3] [nvarchar](100) NOT NULL,
	[Telephone] [nvarchar](50) NOT NULL,
	[Fax] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[IATANumber] [nvarchar](50) NOT NULL,
	[VATRegisterNumber] [nvarchar](15) NOT NULL,
	[ExchangeControlPermitNumber] [nvarchar](15) NOT NULL,
	[VolumeWeightDevideFactor] [decimal](10, 3) NOT NULL,
	[CBMDevideFactor] [decimal](18, 0) NOT NULL,
	[BaseCurrency] [nvarchar](5) NOT NULL,
	[USDCurrency] [nvarchar](5) NOT NULL,
	[ShipperCurrency] [nvarchar](5) NOT NULL,
	[AgentCurrency] [nvarchar](5) NOT NULL,
	[DatabaseBackupPath] [nvarchar](100) NOT NULL,
	[DatabasePath] [nvarchar](100) NOT NULL,
	[LoginFormActive] [bit] NOT NULL,
	[PrintHalfPage] [bit] NOT NULL,
	[PageSizeID] [int] NOT NULL,
	[DataSaveMethod] [nvarchar](20) NOT NULL,
	[EmailFrom] [nvarchar](50) NOT NULL,
	[EmailFromPW] [nvarchar](15) NOT NULL,
	[EmailSMTPPort] [decimal](18, 0) NOT NULL,
	[EmailSMTPServer] [nvarchar](50) NOT NULL,
	[ShortName] [nvarchar](50) NOT NULL,
	[CheckDuplicate] [nvarchar](20) NOT NULL,
	[Delivery] [nvarchar](10) NOT NULL,
	[DeliveryAutoAdd] [bit] NOT NULL,
	[CountryCode] [nvarchar](10) NOT NULL,
	[HubName] [nvarchar](50) NOT NULL,
	[DuplicateBarcodeForSameGRN] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContainerData]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContainerData](
	[BookingDate] [datetime] NULL,
	[VesselOrderNo] [decimal](18, 0) NOT NULL,
	[ContainerOrderNo] [decimal](18, 0) NOT NULL,
	[ContainerNo] [nvarchar](20) NOT NULL,
	[ContainerType] [nvarchar](10) NOT NULL,
	[SealNo] [nvarchar](25) NOT NULL,
	[NextContainerNo] [nvarchar](50) NOT NULL,
	[CntrOut] [bit] NOT NULL,
	[CntrOutDate] [datetime] NULL,
	[CntrOutBy] [nvarchar](10) NOT NULL,
	[PCSBox] [decimal](18, 0) NOT NULL,
	[CtnsBox] [decimal](18, 0) NOT NULL,
	[GrossWgtBox] [money] NOT NULL,
	[CBMBox] [money] NOT NULL,
	[PCSGoh] [decimal](18, 0) NOT NULL,
	[VCPGoh] [decimal](18, 0) NOT NULL,
	[GrossWgtGoh] [money] NOT NULL,
	[CBMGoh] [money] NOT NULL,
	[BarType] [nvarchar](10) NOT NULL,
	[NofBars] [money] NOT NULL,
	[DateCreate] [datetime] NULL,
	[CreateBy] [nvarchar](10) NOT NULL,
	[DateUpdate] [datetime] NULL,
	[DateLastPO] [datetime] NULL,
	[UpdateBy] [nvarchar](10) NOT NULL,
	[SealDate] [datetime] NULL,
	[SealBy] [nvarchar](10) NOT NULL,
	[CntrNoDate] [datetime] NULL,
	[CntrNoBy] [nvarchar](10) NOT NULL,
	[VGM] [money] NOT NULL,
	[SCMLabelNo] [nvarchar](20) NOT NULL,
	[SCMLabelNoTime] [datetime] NULL,
	[InvoiceStatus] [nvarchar](10) NOT NULL,
	[InvoiceNo] [nvarchar](10) NOT NULL,
	[InvoiceTime] [datetime] NULL,
	[InvoiceConfirmStatus] [nvarchar](10) NOT NULL,
	[InvoiceConfirmTime] [datetime] NULL,
	[InvoiceConfirmBy] [nvarchar](10) NOT NULL,
	[IsTallyUpload] [bit] NOT NULL,
	[LastPalletNo] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContainerDataImport]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContainerDataImport](
	[BookingDate] [datetime] NULL,
	[VesselOrderNo] [decimal](18, 0) NOT NULL,
	[ContainerOrderNo] [decimal](18, 0) NOT NULL,
	[ContainerNo] [nvarchar](20) NOT NULL,
	[ContainerType] [nvarchar](10) NOT NULL,
	[SealNo] [nvarchar](25) NOT NULL,
	[NextContainerNo] [nvarchar](50) NOT NULL,
	[CntrOut] [bit] NOT NULL,
	[CntrOutDate] [datetime] NULL,
	[CntrOutBy] [nvarchar](10) NOT NULL,
	[PCSBox] [decimal](18, 0) NOT NULL,
	[CtnsBox] [decimal](18, 0) NOT NULL,
	[GrossWgtBox] [money] NOT NULL,
	[CBMBox] [money] NOT NULL,
	[PCSGoh] [decimal](18, 0) NOT NULL,
	[VCPGoh] [decimal](18, 0) NOT NULL,
	[GrossWgtGoh] [money] NOT NULL,
	[CBMGoh] [money] NOT NULL,
	[BarType] [nvarchar](10) NOT NULL,
	[NofBars] [money] NOT NULL,
	[DateCreate] [datetime] NULL,
	[CreateBy] [nvarchar](10) NOT NULL,
	[DateUpdate] [datetime] NULL,
	[DateLastPO] [datetime] NULL,
	[UpdateBy] [nvarchar](10) NOT NULL,
	[SealDate] [datetime] NULL,
	[SealBy] [nvarchar](10) NOT NULL,
	[CntrNoDate] [datetime] NULL,
	[CntrNoBy] [nvarchar](10) NOT NULL,
	[DOReleaseStatus] [nvarchar](10) NOT NULL,
	[DOReleaseStatusBy] [nvarchar](10) NOT NULL,
	[DOReleaseStatusTime] [datetime] NULL,
	[HBNo] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContainerType]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContainerType](
	[ContainerType] [nvarchar](5) NOT NULL,
	[ContainerName] [nvarchar](25) NOT NULL,
	[DateCreate] [datetime] NULL,
	[CreateBy] [nvarchar](4) NOT NULL,
	[DateUpdate] [datetime] NULL,
	[UpdateBy] [nvarchar](4) NOT NULL,
	[EdiType] [nvarchar](10) NOT NULL,
	[ASYCUDARef] [nvarchar](10) NOT NULL,
	[MaxCBM] [money] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContractForcast]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContractForcast](
	[ContractNo] [nvarchar](50) NOT NULL,
	[Mode] [nvarchar](10) NOT NULL,
	[DeliveryNo] [decimal](18, 0) NOT NULL,
	[Units] [decimal](18, 0) NOT NULL,
	[ExFactoryDate] [datetime] NULL,
	[Departure] [nvarchar](20) NOT NULL,
	[TradeLane] [nvarchar](20) NOT NULL,
	[CargoType] [nvarchar](10) NOT NULL,
	[NextDirect] [nvarchar](10) NULL,
	[Warehouse] [nvarchar](100) NOT NULL,
	[ItemNo] [nvarchar](100) NOT NULL,
	[EnterTime] [datetime] NULL,
	[EnterBy] [nvarchar](10) NOT NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateBy] [nvarchar](10) NOT NULL,
	[ShipperCode] [nvarchar](10) NOT NULL,
	[ExLocalOfficeDate] [datetime] NULL,
	[LocalOfficeStatus] [nvarchar](10) NOT NULL,
	[LocalOfficeStatusTime] [datetime] NULL,
	[LocalOfficeStatusBy] [nvarchar](10) NOT NULL,
	[IntakeStatus] [nvarchar](10) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContractListJMB]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContractListJMB](
	[ContractNo] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContractsChainCodes]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContractsChainCodes](
	[ChainCode] [char](1) NOT NULL,
	[ChainName] [varchar](50) NOT NULL,
	[TPPartnerName] [varchar](20) NOT NULL,
	[Range] [varchar](20) NOT NULL,
	[RangeBoxEAN] [varchar](10) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContractsChainCodesCategory]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContractsChainCodesCategory](
	[Category] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Country]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[CountryCode] [nvarchar](10) NOT NULL,
	[CountryName] [nvarchar](50) NOT NULL,
	[CargoMovement] [nvarchar](10) NOT NULL,
	[DateEnter] [datetime] NULL,
	[EnterBy] [nvarchar](10) NOT NULL,
	[DateUpdate] [datetime] NULL,
	[UpdateBy] [nvarchar](10) NOT NULL,
	[ContractBlock] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Currency]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Currency](
	[CurrencyCode] [nvarchar](5) NOT NULL,
	[CurrencyName] [nvarchar](25) NOT NULL,
	[CurrencySymbol] [nvarchar](5) NOT NULL,
	[CurrencyRate] [money] NOT NULL,
	[CurrencyRateMAWB] [money] NOT NULL,
	[DateCreate] [datetime] NULL,
	[CreateBy] [nvarchar](4) NOT NULL,
	[DateUpdate] [datetime] NULL,
	[UpdateBy] [nvarchar](4) NOT NULL,
	[ASYCUDARef] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_Currency] PRIMARY KEY CLUSTERED 
(
	[CurrencyCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DepartmentCodeColors]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DepartmentCodeColors](
	[DepartmentCode] [varchar](20) NOT NULL,
	[ColorDesciption] [varchar](20) NOT NULL,
	[ColorCode] [varchar](15) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DestStore]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DestStore](
	[WhDesMain] [nvarchar](50) NOT NULL,
	[StoreCode] [nvarchar](50) NOT NULL,
	[StoreName] [nvarchar](50) NOT NULL,
	[StoreLcName] [nvarchar](100) NOT NULL,
	[StoreLcPostalCode] [nvarchar](20) NOT NULL,
	[LoadOrder] [int] NOT NULL,
	[StoreGS128Code] [nvarchar](10) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DestWarehouse]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DestWarehouse](
	[WhCode] [nvarchar](10) NOT NULL,
	[WhDes] [nvarchar](50) NOT NULL,
	[WhDesMain] [nvarchar](20) NOT NULL,
	[CountryCode] [nvarchar](10) NOT NULL,
	[LoadingOrder] [decimal](18, 0) NOT NULL,
	[OuterLabel] [bit] NOT NULL,
	[EANLabelScan] [bit] NOT NULL,
	[ReworkApply] [bit] NOT NULL,
	[RFIDPriceTag] [bit] NOT NULL,
	[RFIDPriceTagValidate] [nvarchar](10) NOT NULL,
	[RemoveOriginalTag] [bit] NOT NULL,
	[JokerTagsForSets] [bit] NOT NULL,
	[CareWarningLabel] [bit] NOT NULL,
	[PreValidationRun] [bit] NOT NULL,
	[EANLabelOuterBox] [bit] NOT NULL,
	[EANDesCol] [nvarchar](10) NOT NULL,
	[PackAdditionalBox] [bit] NOT NULL,
	[BoxPMCode] [nvarchar](10) NOT NULL,
	[HangerUse] [bit] NOT NULL,
	[EANLabelPiece] [bit] NOT NULL,
	[PostValidation] [bit] NOT NULL,
	[StockUpdate] [bit] NOT NULL,
	[AuthorizedToPOPlan] [bit] NOT NULL,
	[ItemOptionFixedLength] [bit] NOT NULL,
	[ItemOptionManual] [bit] NOT NULL,
	[PriceSymble] [nvarchar](10) NOT NULL,
	[PrintPriceTag] [bit] NOT NULL,
	[BoxPackSeperate] [bit] NOT NULL,
	[StorePick] [bit] NOT NULL,
	[IsRfidOrder] [bit] NOT NULL,
	[BrandText] [varchar](50) NULL,
	[BarcodeType] [varchar](50) NOT NULL,
	[ProductCategory] [bit] NOT NULL,
	[VasCheck] [bit] NOT NULL,
	[EnaVerification] [bit] NOT NULL,
	[EanLblType] [varchar](10) NOT NULL,
	[Address] [nvarchar](500) NOT NULL,
	[LpnLblType] [varchar](10) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DestWarehouseMain]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DestWarehouseMain](
	[WhDesMain] [nvarchar](20) NOT NULL,
	[AuthorizedToPOPlan] [bit] NOT NULL,
	[isInILS] [bit] NOT NULL,
	[RfidBuff] [decimal](18, 2) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EPCs]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EPCs](
	[Ref] [varchar](20) NOT NULL,
	[ENA] [varchar](50) NOT NULL,
	[EPC] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExcelBookingFormat]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExcelBookingFormat](
	[BookingFormat] [nvarchar](50) NOT NULL,
	[OriginPortRow] [decimal](18, 0) NOT NULL,
	[OriginPortCol] [decimal](18, 0) NOT NULL,
	[VesselRow] [decimal](18, 0) NOT NULL,
	[VesselCol] [decimal](18, 0) NOT NULL,
	[ETDRow] [decimal](18, 0) NOT NULL,
	[ETDCol] [decimal](18, 0) NOT NULL,
	[PackTypeRow] [decimal](18, 0) NOT NULL,
	[PackTypeCol] [decimal](18, 0) NOT NULL,
	[LoadRefRow] [decimal](18, 0) NOT NULL,
	[LoadRefCol] [decimal](18, 0) NOT NULL,
	[VoyageRow] [decimal](18, 0) NOT NULL,
	[VoyageCol] [decimal](18, 0) NOT NULL,
	[ContainerSizeRow] [decimal](18, 0) NOT NULL,
	[ContainerSizeCol] [decimal](18, 0) NOT NULL,
	[RowStart] [decimal](18, 0) NOT NULL,
	[ContractNo] [decimal](18, 0) NOT NULL,
	[SupplierName] [decimal](18, 0) NOT NULL,
	[PCS] [decimal](18, 0) NOT NULL,
	[Ctns] [decimal](18, 0) NOT NULL,
	[CBM] [decimal](18, 0) NOT NULL,
	[GrsWgt] [decimal](18, 0) NOT NULL,
	[ShipDate] [decimal](18, 0) NULL,
	[DC] [decimal](18, 0) NOT NULL,
	[ItemNo] [decimal](18, 0) NOT NULL,
	[SheetName] [nvarchar](50) NOT NULL,
	[DFLong] [nvarchar](10) NOT NULL,
	[DFShort] [nvarchar](10) NOT NULL,
	[CusdecNo] [decimal](18, 0) NOT NULL,
	[PONo] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExpMWB]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExpMWB](
	[JobNo] [nvarchar](10) NOT NULL,
	[ETD] [datetime] NULL,
	[JobDate] [datetime] NULL,
	[VesselRegistryNo] [decimal](18, 0) NOT NULL,
	[Vessel] [nvarchar](50) NOT NULL,
	[ETA] [datetime] NULL,
	[isCancel] [bit] NOT NULL,
	[CancelBy] [nvarchar](5) NOT NULL,
	[CancelDate] [datetime] NULL,
	[isConfirm] [bit] NOT NULL,
	[ConfirmBy] [nvarchar](4) NOT NULL,
	[ConfirmDate] [datetime] NULL,
	[CreateBy] [nvarchar](5) NOT NULL,
	[CreateDate] [datetime] NULL,
	[UpdateBy] [nvarchar](5) NOT NULL,
	[UpdateDate] [datetime] NULL,
	[LastContainerOrderNo] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExpMWBCntrLoadPlan]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExpMWBCntrLoadPlan](
	[JobNo] [nvarchar](10) NOT NULL,
	[ContainerOrderNo] [decimal](18, 0) NOT NULL,
	[OrderNo] [decimal](18, 0) NOT NULL,
	[RcvNo] [nvarchar](10) NOT NULL,
	[isActive] [bit] NOT NULL,
	[LoadActual] [decimal](18, 0) NOT NULL,
	[LoadPosition] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExpMWBContainerData]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExpMWBContainerData](
	[JobNo] [nvarchar](10) NOT NULL,
	[OrderNo] [decimal](18, 0) NOT NULL,
	[ContainerNo] [nvarchar](20) NOT NULL,
	[ContainerType] [nvarchar](5) NOT NULL,
	[SealNo] [nvarchar](30) NOT NULL,
	[LastLoadOrderNo] [decimal](18, 0) NOT NULL,
	[CurrentLoadOrderNo] [decimal](18, 0) NOT NULL,
	[Positions] [decimal](18, 0) NOT NULL,
	[NextContainerNo] [nvarchar](20) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExpMWBJobNoLast]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExpMWBJobNoLast](
	[JobYear] [decimal](18, 0) NULL,
	[LastJobNo] [decimal](18, 0) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExpVesselRegistry]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExpVesselRegistry](
	[ETD] [datetime] NOT NULL,
	[RegistryNo] [decimal](18, 0) NOT NULL,
	[Vessel] [nvarchar](50) NOT NULL,
	[VoyageNo] [nvarchar](20) NOT NULL,
	[MotherVessel] [nvarchar](50) NOT NULL,
	[MotherVoyageNo] [nvarchar](20) NOT NULL,
	[CutoffTime] [datetime] NULL,
	[OnBoard] [datetime] NULL,
	[PortLoading] [nvarchar](5) NOT NULL,
	[DateCreate] [datetime] NULL,
	[CreateBy] [nvarchar](5) NOT NULL,
	[DateUpdate] [datetime] NULL,
	[UpdateBy] [nvarchar](5) NOT NULL,
	[BirthPlace] [nvarchar](50) NOT NULL,
	[VesselOpCode] [nvarchar](20) NOT NULL,
	[BookingNo] [nvarchar](20) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FactorySupervisor]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactorySupervisor](
	[SupervisorId] [nvarchar](10) NOT NULL,
	[SupervisorName] [nvarchar](50) NOT NULL,
	[SupervisorPW] [nvarchar](10) NOT NULL,
	[DateUpdate] [datetime] NULL,
	[EnterBy] [nvarchar](10) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FieldsLength]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FieldsLength](
	[ContractNoUk] [decimal](18, 0) NOT NULL,
	[ContractNoFranchise] [decimal](18, 0) NOT NULL,
	[ContractNoMockshop] [decimal](18, 0) NOT NULL,
	[ContractNoChoice] [decimal](18, 0) NOT NULL,
	[ItemNoUk] [decimal](18, 0) NOT NULL,
	[ItemNoFranchise] [decimal](18, 0) NOT NULL,
	[ItemNoMockshop] [decimal](18, 0) NOT NULL,
	[ItemNoChoice] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FldCaptions]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FldCaptions](
	[SysCaption] [nvarchar](50) NOT NULL,
	[ContractNoCaption] [nvarchar](20) NOT NULL,
	[ItemNoCaption] [nvarchar](50) NOT NULL,
	[PONoCaption] [nvarchar](50) NOT NULL,
	[DeliveryNoCaption] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FranchiseCountry]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FranchiseCountry](
	[CountryName] [nvarchar](10) NOT NULL,
	[Warehouse] [nvarchar](50) NOT NULL,
	[LoadingOrder] [decimal](18, 0) NOT NULL,
	[isActive] [bit] NOT NULL,
	[PortCode] [nvarchar](10) NOT NULL,
	[TradeLane] [nvarchar](10) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Grn]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Grn](
	[GrnNo] [nvarchar](10) NOT NULL,
	[GrnDate] [datetime] NULL,
	[GrnTime] [datetime] NULL,
	[RefNo] [nvarchar](50) NOT NULL,
	[CusdecNo] [nvarchar](50) NOT NULL,
	[LorryNo] [nvarchar](50) NOT NULL,
	[DriverName] [nvarchar](50) NOT NULL,
	[DriverContactNo] [nvarchar](50) NOT NULL,
	[Remarks] [nvarchar](100) NOT NULL,
	[GateIn] [datetime] NULL,
	[GateOut] [datetime] NULL,
	[TallyStart] [datetime] NULL,
	[TallyEnd] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HangerTemplate]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HangerTemplate](
	[ContractNo] [nvarchar](50) NOT NULL,
	[ItemOption] [nvarchar](10) NOT NULL,
	[PMCode] [nvarchar](12) NOT NULL,
	[QtyNeed] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HangerTypes]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HangerTypes](
	[HangerType] [nvarchar](10) NOT NULL,
	[HangerUseFor] [nvarchar](200) NOT NULL,
	[HangerImage] [image] NULL,
	[HangerWgt] [money] NOT NULL,
	[ListOrder] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HistoryCargoBarCode]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HistoryCargoBarCode](
	[Barcode] [nvarchar](40) NOT NULL,
	[RcvNo] [nvarchar](10) NOT NULL,
	[Location] [nvarchar](10) NOT NULL,
	[Status] [nvarchar](10) NOT NULL,
	[QCYes] [bit] NOT NULL,
	[QCInTime] [datetime] NULL,
	[VerificationYes] [bit] NOT NULL,
	[VerificationInTime] [datetime] NULL,
	[RtnNo] [nvarchar](10) NOT NULL,
	[UpNo] [nvarchar](10) NOT NULL,
	[BarCodePcs] [decimal](18, 0) NOT NULL,
	[BarCodeGrsWgt] [money] NOT NULL,
	[BarCodeNetWgt] [money] NOT NULL,
	[UpLoadCntrNo] [nvarchar](20) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HistoryCargoReceived]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HistoryCargoReceived](
	[RcvNo] [nvarchar](10) NOT NULL,
	[EntryType] [nvarchar](10) NOT NULL,
	[RcvDate] [datetime] NULL,
	[RcvTime] [datetime] NULL,
	[ShipperCode] [nchar](5) NOT NULL,
	[ContractNo] [nvarchar](50) NOT NULL,
	[ItemNo] [nvarchar](50) NOT NULL,
	[InvoiceNo] [nvarchar](50) NOT NULL,
	[PONo] [nvarchar](50) NOT NULL,
	[DeliveryNo] [decimal](18, 0) NOT NULL,
	[ShippingMode] [nvarchar](10) NOT NULL,
	[CargoType] [nvarchar](10) NOT NULL,
	[Ctns] [decimal](18, 0) NOT NULL,
	[PCS] [decimal](18, 0) NOT NULL,
	[ScanQty] [decimal](18, 0) NOT NULL,
	[CBM] [money] NOT NULL,
	[GrossWgt] [money] NOT NULL,
	[LorryNo] [nvarchar](50) NOT NULL,
	[IntakeComments] [nvarchar](200) NOT NULL,
	[WHLocation] [nvarchar](5) NOT NULL,
	[TradeLane] [nvarchar](20) NOT NULL,
	[Country] [nvarchar](20) NOT NULL,
	[Warehouse] [nvarchar](50) NOT NULL,
	[QCType] [nvarchar](10) NOT NULL,
	[EnterBy] [nvarchar](10) NOT NULL,
	[EnterDate] [datetime] NULL,
	[QCStatus] [nvarchar](10) NOT NULL,
	[QCDone] [bit] NOT NULL,
	[QCDoneDate] [datetime] NULL,
	[QCResult] [nvarchar](10) NOT NULL,
	[QCDoneBy] [nvarchar](10) NOT NULL,
	[QCRemarks] [nvarchar](100) NOT NULL,
	[QCDoneTimeSystem] [datetime] NULL,
	[LimaValidate] [bit] NOT NULL,
	[LimaValidateTime] [datetime] NULL,
	[Authorized] [bit] NOT NULL,
	[AuthDate] [datetime] NULL,
	[AuthTime] [datetime] NULL,
	[DC] [nvarchar](20) NOT NULL,
	[LimaShipDate] [datetime] NULL,
	[LimaPLDate] [datetime] NULL,
	[AirCost] [nvarchar](10) NOT NULL,
	[NextToPay] [money] NOT NULL,
	[Verification] [bit] NOT NULL,
	[VerificationDate] [datetime] NULL,
	[VerificationTime] [datetime] NULL,
	[VerificationBy] [nvarchar](10) NOT NULL,
	[RemoveStatus] [nvarchar](10) NOT NULL,
	[RemoveStatusDoneDate] [datetime] NULL,
	[RemoveStatusDoneBy] [nvarchar](10) NOT NULL,
	[RemoveDoneDate] [datetime] NULL,
	[RemoveDoneBy] [nvarchar](10) NOT NULL,
	[RemoveType] [nvarchar](10) NOT NULL,
	[RemovalComments] [nvarchar](200) NOT NULL,
	[InQty] [decimal](18, 0) NOT NULL,
	[RemoveQty] [decimal](18, 0) NOT NULL,
	[DeleteDate] [datetime] NULL,
	[QCStaffCode] [nvarchar](10) NOT NULL,
	[BookingDate] [datetime] NULL,
	[LoadNo] [nvarchar](10) NOT NULL,
	[VesselOrderNo] [decimal](18, 0) NOT NULL,
	[VesselPlanDate] [datetime] NULL,
	[ContainerOrderNo] [decimal](18, 0) NOT NULL,
	[LoadPosition] [decimal](18, 0) NOT NULL,
	[LimaPosition] [decimal](18, 0) NOT NULL,
	[LoadingRef] [nvarchar](10) NOT NULL,
	[ShippingModeIn] [nvarchar](10) NOT NULL,
	[PCSIn] [decimal](18, 0) NOT NULL,
	[CtnsIn] [decimal](18, 0) NOT NULL,
	[CBMIn] [money] NOT NULL,
	[DeliveryNoIn] [decimal](18, 0) NOT NULL,
	[TradeLaneIn] [nvarchar](20) NOT NULL,
	[CountryIn] [nvarchar](20) NOT NULL,
	[QCDate] [datetime] NULL,
	[RemovePartQty] [decimal](18, 0) NOT NULL,
	[RemovePartPCS] [decimal](18, 0) NOT NULL,
	[RemovePartCBM] [money] NOT NULL,
	[RemoveQtyPartScan] [decimal](18, 0) NOT NULL,
	[RemovePartDate] [datetime] NULL,
	[RemovePartBy] [nvarchar](10) NOT NULL,
	[RemovePartQtyRemark] [nvarchar](100) NOT NULL,
	[DateUpdate] [datetime] NULL,
	[UpdateBy] [nvarchar](10) NOT NULL,
	[SplitRcvNo] [nvarchar](10) NOT NULL,
	[LoadType] [nvarchar](10) NOT NULL,
	[LorryNoLoad] [nvarchar](50) NOT NULL,
	[OutTime] [datetime] NULL,
	[OutBy] [nvarchar](10) NOT NULL,
	[OldShippingMode] [nvarchar](10) NOT NULL,
	[OldAirCost] [nvarchar](10) NOT NULL,
	[ModeChangeDate] [datetime] NULL,
	[ModeChangeBy] [nvarchar](10) NOT NULL,
	[ShippingModeQC] [nvarchar](10) NOT NULL,
	[DeliveryNoQC] [decimal](18, 0) NOT NULL,
	[TradeLaneQC] [nvarchar](10) NOT NULL,
	[CountryQC] [nvarchar](10) NOT NULL,
	[QCCtns] [decimal](18, 0) NOT NULL,
	[QCPcs] [decimal](18, 0) NOT NULL,
	[QCPcsReject] [decimal](18, 0) NOT NULL,
	[Descrepancy] [nvarchar](500) NOT NULL,
	[DescrepancyTime] [datetime] NULL,
	[DescrepancyBy] [nvarchar](10) NOT NULL,
	[QCQty] [decimal](18, 0) NOT NULL,
	[VerifyQty] [decimal](18, 0) NOT NULL,
	[InChecked] [bit] NOT NULL,
	[InCheckedComment] [nvarchar](100) NOT NULL,
	[InChechedTime] [datetime] NULL,
	[InCheckedBy] [nvarchar](10) NOT NULL,
	[UpLiftStatus] [nvarchar](10) NOT NULL,
	[UpLiftTime] [datetime] NULL,
	[UpLiftBy] [nvarchar](10) NOT NULL,
	[UnLoadStart] [datetime] NULL,
	[UnLoadEnd] [datetime] NULL,
	[LoadStart] [datetime] NULL,
	[LoadEnd] [datetime] NULL,
	[CargoQuality] [nvarchar](15) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Holidays]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Holidays](
	[Year] [int] NOT NULL,
	[HoliDay] [datetime] NULL,
	[Remark] [nvarchar](100) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InboundContainerData]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InboundContainerData](
	[ETD] [datetime] NULL,
	[VesselOrderNo] [decimal](18, 0) NOT NULL,
	[ContainerOrderNo] [decimal](18, 0) NOT NULL,
	[ContainerNo] [nvarchar](50) NOT NULL,
	[ContainerType] [nvarchar](20) NOT NULL,
	[NextContainerNo] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InBoundVesselRegistry]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InBoundVesselRegistry](
	[ETD] [datetime] NULL,
	[VesselOrderNo] [decimal](18, 0) NOT NULL,
	[VesselName] [nvarchar](50) NOT NULL,
	[Carrier] [nvarchar](50) NOT NULL,
	[VoyageNo] [nvarchar](50) NOT NULL,
	[LastContainerOrderNo] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ItemOptionMap]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ItemOptionMap](
	[ItemOption] [nvarchar](10) NOT NULL,
	[OthItemId] [nvarchar](20) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LastGRNNo]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LastGRNNo](
	[Lno] [decimal](18, 0) NOT NULL,
	[BookingYear] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LastLoadNo]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LastLoadNo](
	[Lno] [decimal](18, 0) NOT NULL,
	[Active] [bit] NOT NULL,
	[PreFix] [char](1) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LastRcvNo]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LastRcvNo](
	[Lno] [decimal](18, 0) NOT NULL,
	[Active] [bit] NOT NULL,
	[PreFix] [char](1) NOT NULL,
	[BookingYear] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LIMAExcelFormat]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LIMAExcelFormat](
	[ColName] [nvarchar](50) NOT NULL,
	[ColCaption] [nvarchar](50) NOT NULL,
	[ColType] [nvarchar](50) NOT NULL,
	[ColLen] [decimal](18, 0) NOT NULL,
	[ColDefVal] [nvarchar](50) NOT NULL,
	[OrderNo] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LIMAExcelFormatAir]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LIMAExcelFormatAir](
	[ColName] [nvarchar](50) NOT NULL,
	[ColCaption] [nvarchar](50) NOT NULL,
	[ColType] [nvarchar](50) NOT NULL,
	[ColLen] [decimal](18, 0) NOT NULL,
	[ColDefVal] [nvarchar](50) NOT NULL,
	[OrderNo] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Locations]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Locations](
	[LocationCode] [nvarchar](15) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MenuTreeViewRelation]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuTreeViewRelation](
	[TreeViewFullPath] [nvarchar](200) NOT NULL,
	[IsMenuItem] [bit] NULL,
	[nMnuNodes] [int] NULL,
	[MnuIndex0] [int] NULL,
	[MnuIndex1] [int] NULL,
	[MnuIndex2] [int] NULL,
	[MnuIndex3] [int] NULL,
	[MnuIndex4] [int] NULL,
	[MnuIndex5] [int] NULL,
	[MnuIndex6] [int] NULL,
	[MnuIndex7] [int] NULL,
	[TrackingDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OkToLoadReason]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OkToLoadReason](
	[Reason] [nvarchar](50) NOT NULL,
	[ReasonOrder] [decimal](18, 0) NOT NULL,
	[DtlReson] [nvarchar](1000) NOT NULL,
	[Warehouse] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OptionSizes]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OptionSizes](
	[OptionNo] [nvarchar](10) NOT NULL,
	[OptionSize] [nvarchar](20) NOT NULL,
	[OptionSizeDescription] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PackJobNo]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackJobNo](
	[JobYear] [decimal](18, 0) NOT NULL,
	[LastJobNo] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PackPOCtnSummary]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackPOCtnSummary](
	[JobNo] [nvarchar](10) NOT NULL,
	[OptionNo] [nvarchar](5) NOT NULL,
	[CtnType] [nvarchar](10) NOT NULL,
	[CtnLength] [money] NOT NULL,
	[CtnWidth] [money] NOT NULL,
	[CtnHeight] [money] NOT NULL,
	[NofCtn] [decimal](18, 0) NOT NULL,
	[CtnWgt] [money] NOT NULL,
	[GrsWgt] [money] NOT NULL,
	[CBM] [money] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PackPoPlan]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackPoPlan](
	[JobNo] [nvarchar](10) NOT NULL,
	[ShipperCode] [nvarchar](10) NOT NULL,
	[ContractNo] [nvarchar](50) NOT NULL,
	[DeliveryNo] [decimal](18, 0) NOT NULL,
	[ItemNo] [nvarchar](50) NOT NULL,
	[Ctns] [decimal](18, 0) NOT NULL,
	[CtnsPack] [decimal](18, 0) NOT NULL,
	[PlanTime] [datetime] NULL,
	[PlanBy] [nvarchar](10) NOT NULL,
	[LastCtnOrderNo] [decimal](18, 0) NOT NULL,
	[CtnsComplete] [decimal](18, 0) NOT NULL,
	[WgtStatus] [nvarchar](10) NOT NULL,
	[WgtStatusBy] [nvarchar](10) NOT NULL,
	[WgtStatusTime] [datetime] NULL,
	[LastWrongNo] [decimal](18, 0) NOT NULL,
	[ScanCompStatus] [nvarchar](50) NOT NULL,
	[ScanCompTime] [datetime] NULL,
	[ScanCompBy] [nvarchar](50) NOT NULL,
	[ProductGroup] [nvarchar](100) NOT NULL,
	[Supplier] [nvarchar](100) NOT NULL,
	[Contact] [nvarchar](100) NOT NULL,
	[BookingRef] [nvarchar](20) NOT NULL,
	[ItemDes] [nvarchar](100) NOT NULL,
	[ShippingMode] [nvarchar](10) NOT NULL,
	[TypeRef] [nvarchar](10) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PackPOPlanCtn]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackPOPlanCtn](
	[JobNo] [nvarchar](10) NOT NULL,
	[CtnOrderNo] [decimal](18, 0) NOT NULL,
	[CtnBarCode] [nvarchar](40) NOT NULL,
	[CtnType] [nvarchar](10) NOT NULL,
	[CtnLength] [money] NOT NULL,
	[CtnWidth] [money] NOT NULL,
	[CtnHeight] [money] NOT NULL,
	[PackQty] [decimal](18, 0) NOT NULL,
	[EnterTime] [datetime] NULL,
	[EnterBy] [nvarchar](10) NOT NULL,
	[OptionSize] [nvarchar](10) NOT NULL,
	[CtnID] [nvarchar](10) NOT NULL,
	[CompleteStatus] [nvarchar](10) NOT NULL,
	[CompleteTime] [datetime] NULL,
	[CompleteBy] [nvarchar](10) NOT NULL,
	[WrongQty] [decimal](18, 0) NOT NULL,
	[GrsWgt] [money] NOT NULL,
	[NetWgt] [money] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PackPOPlanCtnSize]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackPOPlanCtnSize](
	[JobNo] [nvarchar](10) NOT NULL,
	[CtnOrderNo] [decimal](18, 0) NOT NULL,
	[SizeBarcode] [nvarchar](40) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PackPOPlanCtnSizeWrong]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackPOPlanCtnSizeWrong](
	[JobNo] [nvarchar](10) NOT NULL,
	[CtnOrderNo] [decimal](18, 0) NOT NULL,
	[SizeBarcode] [nvarchar](40) NOT NULL,
	[UnlockedBy] [nvarchar](10) NOT NULL,
	[UnlockedTime] [datetime] NULL,
	[ErrorType] [nvarchar](100) NOT NULL,
	[CtnBarCode] [nvarchar](40) NOT NULL,
	[PickDate] [datetime] NOT NULL,
	[SizeCorrect] [nvarchar](20) NOT NULL,
	[ValWrong] [nvarchar](20) NOT NULL,
	[ErrorImage] [image] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PackPoPlanSize]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackPoPlanSize](
	[JobNo] [nvarchar](10) NOT NULL,
	[OptionSize] [nvarchar](10) NOT NULL,
	[OptionSizeDes] [nvarchar](50) NOT NULL,
	[PlanQty] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PalletRacks]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PalletRacks](
	[RackNo] [nvarchar](10) NOT NULL,
	[NofRows] [decimal](18, 0) NOT NULL,
	[NofLayers] [decimal](18, 0) NOT NULL,
	[NofPositions] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PalletRacksUtilization]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PalletRacksUtilization](
	[RackNo] [nvarchar](10) NOT NULL,
	[PositionNo] [nvarchar](10) NOT NULL,
	[GrnNo] [nvarchar](10) NOT NULL,
	[PalletNo] [nvarchar](10) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PalletTypes]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PalletTypes](
	[PalletType] [nvarchar](12) NOT NULL,
	[UnitsHold] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PickENADataSheet]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PickENADataSheet](
	[RcvNo] [nvarchar](10) NOT NULL,
	[ItemOption] [nvarchar](50) NOT NULL,
	[ENA] [nvarchar](50) NOT NULL,
	[Size] [nvarchar](50) NOT NULL,
	[ItemColor] [nvarchar](50) NOT NULL,
	[ItemDes] [nvarchar](100) NOT NULL,
	[InCorrectENA] [nvarchar](50) NOT NULL,
	[DateEnter] [datetime] NULL,
	[EAN123] [varchar](50) NOT NULL,
	[colorOld] [nvarchar](50) NOT NULL,
	[SizeOld] [nvarchar](50) NOT NULL,
	[ItemDesUSA] [nvarchar](100) NOT NULL,
	[EnterSource] [nvarchar](10) NOT NULL,
	[UpdateSource] [nvarchar](10) NOT NULL,
	[SizeUSA] [nvarchar](50) NOT NULL,
	[DateUpdate] [datetime] NULL,
	[DepartmentCode] [varchar](20) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PickENADataSheetDC]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PickENADataSheetDC](
	[RcvNo] [nvarchar](10) NOT NULL,
	[ItemOption] [nvarchar](50) NOT NULL,
	[ENA] [nvarchar](50) NOT NULL,
	[Size] [nvarchar](50) NOT NULL,
	[ItemColor] [nvarchar](50) NOT NULL,
	[ItemDes] [nvarchar](100) NOT NULL,
	[DateEnter] [datetime] NULL,
	[ItemDesUSA] [nvarchar](100) NOT NULL,
	[EnterSource] [nvarchar](10) NOT NULL,
	[UpdateSource] [nvarchar](10) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PickSwingTicketData]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PickSwingTicketData](
	[RcvNo] [nvarchar](10) NOT NULL,
	[BarCode] [nvarchar](40) NOT NULL,
	[SwingTicketBarCode] [nvarchar](40) NOT NULL,
	[ErrorDes] [nvarchar](50) NOT NULL,
	[ReworkOk] [bit] NOT NULL,
	[EPCNo] [varchar](30) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PicsExport]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PicsExport](
	[BookingDate] [datetime] NULL,
	[VesselOrderNo] [decimal](18, 0) NOT NULL,
	[ContainerOrderNo] [decimal](18, 0) NOT NULL,
	[PicPath] [nvarchar](100) NULL,
	[PicName] [nvarchar](100) NOT NULL,
	[Remarks] [nvarchar](500) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PicsImport]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PicsImport](
	[BookingDate] [datetime] NULL,
	[VesselOrderNo] [decimal](18, 0) NOT NULL,
	[ContainerOrderNo] [decimal](18, 0) NOT NULL,
	[PicPath] [nvarchar](100) NOT NULL,
	[PicName] [nvarchar](100) NOT NULL,
	[Remarks] [nvarchar](500) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PicsRework]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PicsRework](
	[RcvNo] [nvarchar](10) NOT NULL,
	[PicPath] [nvarchar](100) NOT NULL,
	[PicName] [nvarchar](100) NOT NULL,
	[Remarks] [nvarchar](500) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PicsTmp]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PicsTmp](
	[UserId] [nvarchar](10) NOT NULL,
	[PicPath] [nvarchar](500) NOT NULL,
	[PicName] [nvarchar](100) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PicsUnload]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PicsUnload](
	[RcvNo] [nvarchar](10) NOT NULL,
	[PicPath] [nvarchar](100) NOT NULL,
	[PicName] [nvarchar](100) NOT NULL,
	[Remarks] [nvarchar](500) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PmAllowedSizes]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PmAllowedSizes](
	[Size] [nvarchar](50) NOT NULL,
	[SizeUsa] [nvarchar](50) NOT NULL,
	[PMCode] [nvarchar](12) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PMBoxIssue]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PMBoxIssue](
	[IssueDate] [datetime] NULL,
	[PMCode] [nvarchar](10) NOT NULL,
	[CBM] [money] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PMCategories]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PMCategories](
	[PMCategory] [nvarchar](10) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PMCategoryEnPoints]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PMCategoryEnPoints](
	[PMCategory] [nvarchar](12) NOT NULL,
	[EnPoint] [nvarchar](2) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PMIn]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PMIn](
	[InNo] [nvarchar](10) NOT NULL,
	[PMIndate] [datetime] NULL,
	[Remarks] [nvarchar](50) NOT NULL,
	[EnterBy] [nvarchar](10) NOT NULL,
	[EnterDate] [datetime] NULL,
	[UpdateBy] [nvarchar](10) NOT NULL,
	[UpdateDate] [datetime] NULL,
	[PMSupplierCode] [nvarchar](5) NOT NULL,
	[IsCancelled] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PMInDtl]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PMInDtl](
	[InNo] [nvarchar](10) NOT NULL,
	[PMCode] [nvarchar](10) NOT NULL,
	[PMQty] [money] NOT NULL,
	[CBM] [money] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PMIssueContract]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PMIssueContract](
	[RcvNo] [nvarchar](10) NOT NULL,
	[PMCode] [nvarchar](12) NOT NULL,
	[IssueCBM] [money] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PMMaster]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PMMaster](
	[PMCode] [nvarchar](12) NOT NULL,
	[PMDescription] [nvarchar](50) NOT NULL,
	[PMCategory] [nvarchar](10) NOT NULL,
	[PMIssueType] [nvarchar](10) NOT NULL,
	[QtyInHand] [decimal](18, 0) NOT NULL,
	[QtyReOrderLevel] [decimal](18, 0) NOT NULL,
	[PMWgt] [money] NOT NULL,
	[PMCBM] [money] NOT NULL,
	[GetJokerCount] [bit] NOT NULL,
	[GetPartCount] [bit] NOT NULL,
	[GetCtnCount] [bit] NOT NULL,
	[StockCBM] [money] NOT NULL,
	[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PMOut]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PMOut](
	[OutNo] [nvarchar](10) NOT NULL,
	[PMOutDate] [datetime] NOT NULL,
	[RcvNo] [nvarchar](10) NOT NULL,
	[EnterBy] [nvarchar](10) NOT NULL,
	[EnterDate] [datetime] NULL,
	[UpdateBy] [nvarchar](10) NOT NULL,
	[UpdateDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PMOutDtl]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PMOutDtl](
	[OutNo] [nvarchar](10) NOT NULL,
	[PMCode] [nvarchar](10) NOT NULL,
	[PMQty] [money] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PMStockIssue]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PMStockIssue](
	[DateAndTime] [datetime] NULL,
	[PMCode] [nvarchar](10) NOT NULL,
	[CBM] [money] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PMSupplier]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PMSupplier](
	[PMSupplierCode] [nvarchar](5) NOT NULL,
	[PMSupplierName] [nvarchar](50) NOT NULL,
	[PMSupplierAddress1] [nvarchar](50) NOT NULL,
	[PMSupplierAddress2] [nvarchar](50) NOT NULL,
	[PMSupplierAddress3] [nvarchar](50) NOT NULL,
	[PMSupplierAddress4] [nvarchar](50) NOT NULL,
	[PMSupplierContact1] [nvarchar](50) NOT NULL,
	[PMSupplierContact2] [nvarchar](50) NOT NULL,
	[PMSupplierContact3] [nvarchar](50) NOT NULL,
	[PMSupplierTel] [nvarchar](50) NOT NULL,
	[PMSupplierEmail] [nvarchar](50) NOT NULL,
	[PMSupplierFax] [nvarchar](50) NOT NULL,
	[CountryCode] [nvarchar](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PMTemplate]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PMTemplate](
	[DC] [nvarchar](50) NOT NULL,
	[OrderNo] [decimal](18, 0) NOT NULL,
	[UnitType] [nvarchar](10) NOT NULL,
	[PMCode] [nvarchar](12) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PMWastage]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PMWastage](
	[PMWastageNo] [nvarchar](10) NOT NULL,
	[PMWastagedate] [datetime] NULL,
	[Remarks] [nvarchar](50) NOT NULL,
	[EnterBy] [nvarchar](10) NOT NULL,
	[EnterDate] [datetime] NULL,
	[UpdateBy] [nvarchar](10) NOT NULL,
	[UpdateDate] [datetime] NULL,
	[IsCancelled] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PMWastageDtl]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PMWastageDtl](
	[PMWastageNo] [nvarchar](10) NOT NULL,
	[PMCode] [nvarchar](10) NOT NULL,
	[PMQty] [money] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ports]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ports](
	[PortCode] [nvarchar](10) NOT NULL,
	[PortName] [nvarchar](50) NOT NULL,
	[CountryCode] [nvarchar](10) NOT NULL,
	[DateCreate] [datetime] NULL,
	[CreateBy] [nvarchar](10) NOT NULL,
	[DateUpdate] [datetime] NULL,
	[UpdateBy] [nvarchar](10) NOT NULL,
	[SeaOrAirPort] [nvarchar](10) NOT NULL,
	[IsDivertable] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PriceTagConfig]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PriceTagConfig](
	[Id] [nvarchar](10) NOT NULL,
	[TotLength] [decimal](18, 0) NOT NULL,
	[Des] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PriceTagConfigDtl]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PriceTagConfigDtl](
	[Id] [nvarchar](10) NOT NULL,
	[OrderNo] [decimal](18, 0) NOT NULL,
	[PosFrom] [decimal](18, 0) NOT NULL,
	[PosTo] [decimal](18, 0) NOT NULL,
	[Caption] [nvarchar](50) NOT NULL,
	[Matching] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PwInfo]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PwInfo](
	[UserId] [nvarchar](50) NOT NULL,
	[PassWord] [nvarchar](50) NOT NULL,
	[Department] [nchar](1) NULL,
	[Datecreate] [datetime] NULL,
	[UserLevel] [nvarchar](50) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[DateUpdate] [datetime] NULL,
	[IsNewOption] [bit] NOT NULL,
	[IsEditOption] [bit] NOT NULL,
	[IsPrintOption] [bit] NOT NULL,
	[IsConfirmOption] [bit] NOT NULL,
	[IsReConfirmOption] [bit] NOT NULL,
	[IsSignOption] [bit] NOT NULL,
	[IsCancelOption] [bit] NOT NULL,
	[IsOtherOption] [bit] NOT NULL,
	[isConfirmAC] [bit] NOT NULL,
	[isReEdit] [bit] NOT NULL,
	[UserCategory] [nvarchar](15) NOT NULL,
	[EmailAddress] [nvarchar](50) NOT NULL,
	[InitMenuId] [nvarchar](20) NOT NULL,
	[InitController] [nvarchar](50) NOT NULL,
	[InitAction] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_PwInfo] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PwInfoDC]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PwInfoDC](
	[UserId] [nvarchar](10) NOT NULL,
	[DC] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PwInfoShippers]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PwInfoShippers](
	[UserId] [nvarchar](50) NOT NULL,
	[ShipperCode] [nvarchar](10) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QCStaff]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QCStaff](
	[StaffCode] [nvarchar](10) NOT NULL,
	[StaffName] [nvarchar](50) NOT NULL,
	[DateEnter] [datetime] NULL,
	[EnterBy] [nvarchar](5) NOT NULL,
	[DateUpdate] [datetime] NULL,
	[UpdateBy] [nvarchar](5) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RackBuild]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RackBuild](
	[RackNo] [nvarchar](10) NOT NULL,
	[LocationId] [nvarchar](10) NOT NULL,
	[RcvNo] [nvarchar](10) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RateCFSExport]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RateCFSExport](
	[ChgCode] [nvarchar](10) NOT NULL,
	[ChgDescription] [nvarchar](50) NOT NULL,
	[UnitType] [nvarchar](10) NOT NULL,
	[Range1] [money] NOT NULL,
	[Range2] [money] NOT NULL,
	[UnitCalType] [nvarchar](10) NULL,
	[RateInUSD] [money] NOT NULL,
	[isActive] [bit] NOT NULL,
	[FileCaption] [nvarchar](50) NOT NULL,
	[MaterialCode] [nvarchar](10) NOT NULL,
	[RateinUSDCost] [numeric](18, 0) NOT NULL,
	[RateUpdateBy] [nvarchar](10) NOT NULL,
	[RateUpdateDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RateClearHaulageExport]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RateClearHaulageExport](
	[CntrType] [nvarchar](10) NOT NULL,
	[RateInUSD] [money] NOT NULL,
	[RateUpdateBy] [nvarchar](10) NOT NULL,
	[RateUpdateDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RateFreightExport]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RateFreightExport](
	[PortCode] [nvarchar](10) NOT NULL,
	[CntrType] [nvarchar](10) NOT NULL,
	[RateInUSD] [money] NOT NULL,
	[RateUpdateBy] [nvarchar](10) NOT NULL,
	[RateUpdateDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RFIDData]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFIDData](
	[ContractNo] [nvarchar](20) NOT NULL,
	[DeliveryNo] [decimal](18, 0) NOT NULL,
	[ItemNo] [nvarchar](10) NOT NULL,
	[DCMain] [nvarchar](20) NOT NULL,
	[GlobalBrand] [nvarchar](50) NOT NULL,
	[GarmentType] [nvarchar](50) NOT NULL,
	[Phase] [nvarchar](10) NOT NULL,
	[SupplierRef] [nvarchar](50) NOT NULL,
	[DateEnter] [datetime] NULL,
	[ItemOptionLookup] [varchar](10) NOT NULL,
	[RFIDOrderStatus] [varchar](10) NOT NULL,
	[RFIDOrderDate] [datetime] NULL,
	[RFIDOrderBy] [varchar](10) NOT NULL,
	[RFIDOrderRef] [varchar](16) NOT NULL,
	[RfidAvailableDate] [datetime] NULL,
	[DC] [varchar](50) NOT NULL,
	[NofParts] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RFIDDataDtl]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFIDDataDtl](
	[ContractNo] [nvarchar](20) NOT NULL,
	[DeliveryNo] [decimal](18, 0) NOT NULL,
	[ItemNo] [nvarchar](10) NOT NULL,
	[ItemOption] [nvarchar](10) NOT NULL,
	[DCMain] [nvarchar](20) NOT NULL,
	[DateEnter] [datetime] NULL,
	[PartSet] [nvarchar](50) NOT NULL,
	[EAN] [nvarchar](50) NOT NULL,
	[ItemDes] [nvarchar](100) NOT NULL,
	[ItemSize] [nvarchar](20) NOT NULL,
	[ItemColor] [nvarchar](50) NOT NULL,
	[RtlPrice] [money] NOT NULL,
	[Qty] [decimal](18, 0) NOT NULL,
	[NofParts] [decimal](18, 0) NOT NULL,
	[NofJokers] [decimal](18, 0) NOT NULL,
	[QtyBal] [decimal](18, 0) NOT NULL,
	[Department] [nvarchar](20) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RFIDDataHangers]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFIDDataHangers](
	[ItemOption] [nvarchar](10) NOT NULL,
	[H497] [decimal](18, 0) NOT NULL,
	[H498] [decimal](18, 0) NOT NULL,
	[H6008] [decimal](18, 0) NOT NULL,
	[H6010] [decimal](18, 0) NOT NULL,
	[H3315] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RFIDEPCData]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFIDEPCData](
	[OrderRef] [varchar](16) NOT NULL,
	[EPCNo] [varchar](30) NOT NULL,
	[EAN] [varchar](20) NOT NULL,
	[StockVerify] [bit] NULL,
	[Attach] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RFIDOrderRef]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFIDOrderRef](
	[OrderRef] [varchar](16) NOT NULL,
	[OrderDate] [datetime] NULL,
	[OrderBy] [varchar](50) NOT NULL,
	[OrderDateSys] [datetime] NULL,
	[RcvdDate] [datetime] NULL,
	[RcvdDateSys] [datetime] NULL,
	[RcvdEnterBy] [varchar](50) NOT NULL,
	[EPCDataUpload] [bit] NOT NULL,
	[EPCDataUploadDate] [date] NULL,
	[EPCDataUploadBy] [nvarchar](10) NOT NULL,
	[StockVerifyStatus] [varchar](10) NOT NULL,
	[StockVerifyDate] [datetime] NULL,
	[StockVerifyBy] [varchar](100) NULL,
	[DateLastUpdate] [datetime] NOT NULL,
	[Status] [varchar](20) NOT NULL,
 CONSTRAINT [PK_RFIDOrderRef] PRIMARY KEY CLUSTERED 
(
	[OrderRef] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SeaRates]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SeaRates](
	[Stuffing40_CBM] [money] NOT NULL,
	[Stuffing20_CBM] [money] NOT NULL,
	[BLFee_BL] [money] NOT NULL,
	[Rigging_Bar] [money] NOT NULL,
	[Hanging_Bar] [money] NOT NULL,
	[Partion_Cntr] [money] NOT NULL,
	[MgmtFee_20] [money] NOT NULL,
	[MgmtFee_40] [money] NOT NULL,
	[UpdateBy] [nvarchar](10) NOT NULL,
	[UpdateTime] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShipmentChangeTracking]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShipmentChangeTracking](
	[RcvNo] [nvarchar](10) NOT NULL,
	[DateDone] [datetime] NULL,
	[DoneBy] [nvarchar](10) NOT NULL,
	[Activity] [nvarchar](40) NOT NULL,
	[Remarks] [nvarchar](400) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShipmentTypes]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShipmentTypes](
	[ShipmentType] [nvarchar](10) NOT NULL,
	[QcYes] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Shipper]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Shipper](
	[ShipperCode] [nvarchar](5) NOT NULL,
	[ShipperName] [nvarchar](50) NOT NULL,
	[ShipperAddress1] [nvarchar](50) NOT NULL,
	[ShipperAddress2] [nvarchar](50) NOT NULL,
	[ShipperAddress3] [nvarchar](50) NOT NULL,
	[ShipperAddress4] [nvarchar](50) NOT NULL,
	[ShipperContact1] [nvarchar](50) NOT NULL,
	[ShipperContact2] [nvarchar](50) NOT NULL,
	[ShipperContact3] [nvarchar](50) NOT NULL,
	[DateCreate] [datetime] NULL,
	[CreateBy] [nvarchar](5) NOT NULL,
	[DateUpdate] [datetime] NULL,
	[UpdateBy] [nvarchar](5) NOT NULL,
	[ShipperCodeAir] [nvarchar](5) NOT NULL,
	[ShipperCodeSea] [nvarchar](5) NOT NULL,
	[ShipperTel] [nvarchar](50) NOT NULL,
	[ShipperEmail] [nvarchar](50) NOT NULL,
	[ShipperFax] [nvarchar](50) NOT NULL,
	[CountryCode] [nvarchar](10) NULL,
	[LimaSupplierCode] [nvarchar](10) NOT NULL,
	[REXNo] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SplitENADataSheet]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SplitENADataSheet](
	[ContractNo] [varchar](50) NOT NULL,
	[DeliveryNo] [decimal](18, 0) NOT NULL,
	[ItemOption] [varchar](50) NOT NULL,
	[DateEnter] [datetime] NULL,
	[EnterBy] [nvarchar](10) NOT NULL,
	[ReciveDate] [datetime] NULL,
	[IsSplited] [bit] NOT NULL,
	[IsChecked] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StatusCodes]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StatusCodes](
	[StatusCode] [varchar](5) NOT NULL,
	[StatusDes] [varchar](50) NOT NULL,
	[StatusTable] [varchar](100) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TradeLanes]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TradeLanes](
	[TradeLane] [nvarchar](10) NOT NULL,
	[CheckDuplicate] [nvarchar](20) NOT NULL,
	[Delivery] [nvarchar](10) NOT NULL,
	[DeliveryAutoAdd] [bit] NOT NULL,
	[ContractLegth] [decimal](18, 0) NOT NULL,
	[ItemLength] [decimal](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserInfo]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserInfo](
	[UserId] [nvarchar](10) NOT NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[UserEmail] [nvarchar](100) NOT NULL,
	[UserCategory] [nvarchar](10) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRights]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRights](
	[TreeViewFullPath] [nvarchar](200) NOT NULL,
	[UserId] [nvarchar](4) NOT NULL,
	[MenuId] [nvarchar](200) NULL,
	[TrackingDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VesselRegistry]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VesselRegistry](
	[BookingDate] [datetime] NULL,
	[VesselOrderNo] [decimal](18, 0) NOT NULL,
	[VesselName] [nvarchar](50) NOT NULL,
	[Carrier] [nvarchar](50) NOT NULL,
	[VoyageNo] [nvarchar](20) NOT NULL,
	[ETD] [datetime] NULL,
	[CutOff] [datetime] NULL,
	[OnBoard] [datetime] NULL,
	[ETA] [datetime] NULL,
	[DestPort] [nvarchar](10) NOT NULL,
	[LastContainerOrderNo] [decimal](18, 0) NOT NULL,
	[VesselBookingNo] [nvarchar](20) NULL,
	[DateEnter] [datetime] NULL,
	[EnterBy] [nvarchar](10) NOT NULL,
	[DateUpdate] [datetime] NULL,
	[UpdateBy] [nvarchar](10) NOT NULL,
	[Locked] [bit] NOT NULL,
	[LockedBy] [nvarchar](10) NOT NULL,
	[LockedDate] [datetime] NULL,
	[SFOSJobNo] [nvarchar](10) NOT NULL,
	[SFOSJobNoEnterBy] [nvarchar](10) NOT NULL,
	[SFOSJobNoEnterTime] [datetime] NULL,
	[SFOSJobConfirm] [bit] NOT NULL,
	[SFOSJobConfirmBy] [nvarchar](10) NOT NULL,
	[SFOSJobConfirmTime] [datetime] NULL,
	[VoyageNoLima] [nvarchar](20) NOT NULL,
	[MBLNo] [nvarchar](50) NOT NULL,
	[DC] [nvarchar](50) NOT NULL,
	[CntrGateOut] [bit] NOT NULL,
	[DestReachStatus] [nvarchar](10) NOT NULL,
	[DestReachBy] [nvarchar](10) NOT NULL,
	[DestReachTime] [datetime] NULL,
	[DestCountry] [nvarchar](10) NOT NULL,
	[ShipMode] [nvarchar](10) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VesselRegistryImport]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VesselRegistryImport](
	[BookingDate] [datetime] NULL,
	[VesselOrderNo] [decimal](18, 0) NOT NULL,
	[VesselName] [nvarchar](50) NOT NULL,
	[Carrier] [nvarchar](50) NOT NULL,
	[VoyageNo] [nvarchar](20) NOT NULL,
	[ETD] [datetime] NULL,
	[CutOff] [datetime] NULL,
	[OnBoard] [datetime] NULL,
	[ETA] [datetime] NULL,
	[DestPort] [nvarchar](10) NOT NULL,
	[LastContainerOrderNo] [decimal](18, 0) NOT NULL,
	[VesselBookingNo] [nvarchar](20) NULL,
	[DateEnter] [datetime] NULL,
	[EnterBy] [nvarchar](10) NOT NULL,
	[DateUpdate] [datetime] NULL,
	[UpdateBy] [nvarchar](10) NOT NULL,
	[Locked] [bit] NOT NULL,
	[LockedBy] [nvarchar](10) NOT NULL,
	[LockedDate] [datetime] NULL,
	[VoyageNoLima] [nvarchar](20) NOT NULL,
	[MBLNo] [nvarchar](50) NOT NULL,
	[ArrivalStatus] [nvarchar](10) NOT NULL,
	[ArrivalStatusBy] [nvarchar](10) NOT NULL,
	[ArrivalStatusTime] [datetime] NULL,
	[CountryCode] [nvarchar](10) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VesselSeaRates]    Script Date: 10/18/2026 10:38:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VesselSeaRates](
	[BookingDate] [datetime] NULL,
	[VesselOrderNo] [decimal](18, 0) NOT NULL,
	[Stuffing40_CBM] [money] NOT NULL,
	[Stuffing20_CBM] [money] NOT NULL,
	[BLFee_BL] [money] NOT NULL,
	[Rigging_Bar] [money] NOT NULL,
	[Hanging_Bar] [money] NOT NULL,
	[Partion_Cntr] [money] NOT NULL,
	[MgmtFee_20] [money] NOT NULL,
	[MgmtFee_40] [money] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_CargoBarCode_Main]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_CargoBarCode_Main] ON [dbo].[CargoBarCode]
(
	[RcvNo] ASC,
	[BarCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_CargoBarCode_RcvNo]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_CargoBarCode_RcvNo] ON [dbo].[CargoBarCode]
(
	[RcvNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_CargoManualBox_Main]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_CargoManualBox_Main] ON [dbo].[CargoBarCode]
(
	[RcvNo] ASC,
	[BarCode] ASC,
	[FirewallOK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_CargoBarcodeCtnOut_RcvNo]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_CargoBarcodeCtnOut_RcvNo] ON [dbo].[CargoBarcodeCtnOut]
(
	[RcvNo] ASC,
	[BoxId] ASC,
	[StoreCode] ASC,
	[ItemOption] ASC,
	[PackQty] ASC,
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_CargoBarcodePMUsage_RcvNo]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_CargoBarcodePMUsage_RcvNo] ON [dbo].[CargoBarcodePMUsage]
(
	[RcvNo] ASC,
	[Barcode] ASC,
	[PMCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_CargoItemOption_Main]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_CargoItemOption_Main] ON [dbo].[CargoItemOption]
(
	[RcvNo] ASC,
	[ItemOption] ASC,
	[OptionSize] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_CargoItemOptionRFID_ContractNo_DeliveryNo_ItemOption]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_CargoItemOptionRFID_ContractNo_DeliveryNo_ItemOption] ON [dbo].[CargoItemOptionRFID]
(
	[ContractNo] ASC,
	[DeliveryNo] ASC,
	[ItemOption] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_CargoPallets_RcvNo]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_CargoPallets_RcvNo] ON [dbo].[CargoPallets]
(
	[RcvNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_CargoReceived_BookingDate_VesselOrderNo_ContainerOrderNo]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_CargoReceived_BookingDate_VesselOrderNo_ContainerOrderNo] ON [dbo].[CargoReceived]
(
	[BookingDate] ASC,
	[VesselOrderNo] ASC,
	[ContainerOrderNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_CargoReceived_BookingStatus_ETD_ReachedDest]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_CargoReceived_BookingStatus_ETD_ReachedDest] ON [dbo].[CargoReceived]
(
	[BookingStatus] ASC,
	[ReachedDest] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_CargoReceived_BookingStatus_InboundETD_ReachedDest]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_CargoReceived_BookingStatus_InboundETD_ReachedDest] ON [dbo].[CargoReceived]
(
	[BookingStatus] ASC,
	[InboundETD] ASC,
	[ReachedDest] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_CargoReceived_ContractNo_DeliveryNo]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_CargoReceived_ContractNo_DeliveryNo] ON [dbo].[CargoReceived]
(
	[ContractNo] ASC,
	[DeliveryNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_CargoReceived_RcvNo]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_CargoReceived_RcvNo] ON [dbo].[CargoReceived]
(
	[RcvNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_CargoReceived_RcvNo_ContractNo_ItemNo_DeliveryNo]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_CargoReceived_RcvNo_ContractNo_ItemNo_DeliveryNo] ON [dbo].[CargoReceived]
(
	[RcvNo] ASC,
	[ContractNo] ASC,
	[ItemNo] ASC,
	[DeliveryNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_CargoReceived_Statuses]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_CargoReceived_Statuses] ON [dbo].[CargoReceived]
(
	[RcvNo] ASC,
	[ContractNo] ASC,
	[DeliveryNo] ASC,
	[ItemNo] ASC,
	[Warehouse] ASC,
	[VesselOrderNo] ASC,
	[ContainerOrderNo] ASC,
	[UnloadStatus] ASC,
	[PickPackStatus] ASC,
	[RemoveStatus] ASC,
	[ReWorkQty] ASC,
	[InPCS] ASC,
	[PackPCS] ASC,
	[BookingDate] ASC,
	[FirewallStatus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_CargoStorePickPlan]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_CargoStorePickPlan] ON [dbo].[CargoStorePickPlan]
(
	[RcvNo] ASC,
	[ItemOption] ASC,
	[StoreCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_ContainerData]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_ContainerData] ON [dbo].[ContainerData]
(
	[BookingDate] ASC,
	[VesselOrderNo] ASC,
	[ContainerOrderNo] ASC,
	[ContainerNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_ContainerData_BookingDate_VesselOrderNo_ContainerOrderNo]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_ContainerData_BookingDate_VesselOrderNo_ContainerOrderNo] ON [dbo].[ContainerData]
(
	[BookingDate] ASC,
	[VesselOrderNo] ASC,
	[ContainerOrderNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_ContainerDataImport_BookingDate_VesselOrderNo_ContainerOrderNo]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_ContainerDataImport_BookingDate_VesselOrderNo_ContainerOrderNo] ON [dbo].[ContainerDataImport]
(
	[BookingDate] ASC,
	[VesselOrderNo] ASC,
	[ContainerOrderNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_ContainerDataImport_Columns]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_ContainerDataImport_Columns] ON [dbo].[ContainerDataImport]
(
	[BookingDate] ASC,
	[VesselOrderNo] ASC,
	[ContainerOrderNo] ASC,
	[ContainerNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_Country_CountryCode]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_Country_CountryCode] ON [dbo].[Country]
(
	[CountryCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_DestStore_Columns]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_DestStore_Columns] ON [dbo].[DestStore]
(
	[WhDesMain] ASC,
	[StoreCode] ASC,
	[LoadOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_DestWarehouse_WhDes]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_DestWarehouse_WhDes] ON [dbo].[DestWarehouse]
(
	[WhDesMain] ASC,
	[WhDes] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_DestWarehouse_WhDes_only]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_DestWarehouse_WhDes_only] ON [dbo].[DestWarehouse]
(
	[WhDes] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_GRN_GRNNo]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_GRN_GRNNo] ON [dbo].[Grn]
(
	[GrnNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_PickENADataSheet_ItemOption]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_PickENADataSheet_ItemOption] ON [dbo].[PickENADataSheet]
(
	[ItemOption] ASC,
	[ENA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_Ports_PortCode]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_Ports_PortCode] ON [dbo].[Ports]
(
	[PortCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_PWinfo_UserId]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_PWinfo_UserId] ON [dbo].[PwInfo]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_RFIDData_Columns]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_RFIDData_Columns] ON [dbo].[RFIDData]
(
	[ContractNo] ASC,
	[ItemNo] ASC,
	[DCMain] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_RFIDData_ContractNo_DeliveryNo_DCMain]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_RFIDData_ContractNo_DeliveryNo_DCMain] ON [dbo].[RFIDData]
(
	[ContractNo] ASC,
	[DeliveryNo] ASC,
	[DCMain] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_RFIDData_ItemOptionLookup_RFIDOrderStatus]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_RFIDData_ItemOptionLookup_RFIDOrderStatus] ON [dbo].[RFIDData]
(
	[ItemOptionLookup] ASC,
	[RFIDOrderStatus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_RFIDDataDtl_ContractNo_DeliveryNo_ItemOption]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_RFIDDataDtl_ContractNo_DeliveryNo_ItemOption] ON [dbo].[RFIDDataDtl]
(
	[ContractNo] ASC,
	[DeliveryNo] ASC,
	[ItemOption] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_RFIDDataDtl_Main]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_RFIDDataDtl_Main] ON [dbo].[RFIDDataDtl]
(
	[ContractNo] ASC,
	[ItemNo] ASC,
	[ItemOption] ASC,
	[RtlPrice] ASC,
	[EAN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_Shipper_ShipperCode]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_Shipper_ShipperCode] ON [dbo].[Shipper]
(
	[ShipperCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_VesselRegistry_BookingDate_VesselOrderNo]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_VesselRegistry_BookingDate_VesselOrderNo] ON [dbo].[VesselRegistry]
(
	[BookingDate] ASC,
	[VesselOrderNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_VesselRegistry_Columns]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_VesselRegistry_Columns] ON [dbo].[VesselRegistry]
(
	[BookingDate] ASC,
	[VesselOrderNo] ASC,
	[VesselName] ASC,
	[ETD] ASC,
	[ETA] ASC,
	[VesselBookingNo] ASC,
	[DC] ASC,
	[CntrGateOut] ASC,
	[DestReachStatus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_VesselRegistryImport_BookingDate_VesselOrderNo]    Script Date: 10/18/2026 10:38:14 AM ******/
CREATE NONCLUSTERED INDEX [idx_VesselRegistryImport_BookingDate_VesselOrderNo] ON [dbo].[VesselRegistryImport]
(
	[BookingDate] ASC,
	[VesselOrderNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ACVStaff] ADD  CONSTRAINT [DF_ACVStaff_StaffName]  DEFAULT ('') FOR [StaffName]
GO
ALTER TABLE [dbo].[ACVStaff] ADD  CONSTRAINT [DF_ACVStaff_IDNo]  DEFAULT ('') FOR [IDNo]
GO
ALTER TABLE [dbo].[AlarmDevice] ADD  CONSTRAINT [DF_AlarmDevice_DeviceName]  DEFAULT ('') FOR [DeviceName]
GO
ALTER TABLE [dbo].[AlarmDevice] ADD  CONSTRAINT [DF_AlarmDevice_DeviceStatus]  DEFAULT ((0)) FOR [DeviceStatus]
GO
ALTER TABLE [dbo].[BarCodeConfig] ADD  CONSTRAINT [DF_BarCodeConfig_Id_1]  DEFAULT ('') FOR [Id]
GO
ALTER TABLE [dbo].[BarCodeConfig] ADD  CONSTRAINT [DF_BarCodeConfig_TotLength]  DEFAULT ((0)) FOR [TotLength]
GO
ALTER TABLE [dbo].[BarCodeConfig] ADD  CONSTRAINT [DF_BarCodeConfig_Des]  DEFAULT ('') FOR [Des]
GO
ALTER TABLE [dbo].[BarCodeConfigDtl] ADD  CONSTRAINT [DF_BarCodeConfig_Id]  DEFAULT ('') FOR [Id]
GO
ALTER TABLE [dbo].[BarCodeConfigDtl] ADD  CONSTRAINT [DF_BarCodeConfigDtl_OrderNo]  DEFAULT ((0)) FOR [OrderNo]
GO
ALTER TABLE [dbo].[BarCodeConfigDtl] ADD  CONSTRAINT [DF_BarCodeConfig_PosFrom]  DEFAULT ((0)) FOR [PosFrom]
GO
ALTER TABLE [dbo].[BarCodeConfigDtl] ADD  CONSTRAINT [DF_BarCodeConfig_PosTo]  DEFAULT ((0)) FOR [PosTo]
GO
ALTER TABLE [dbo].[BarCodeConfigDtl] ADD  CONSTRAINT [DF_BarCodeConfig_Caption]  DEFAULT ('') FOR [Caption]
GO
ALTER TABLE [dbo].[BarCodeConfigDtl] ADD  CONSTRAINT [DF_BarCodeConfig_Matching]  DEFAULT ((0)) FOR [Matching]
GO
ALTER TABLE [dbo].[BarCodeItemCategory] ADD  CONSTRAINT [DF_BarCodeItemCategory_ItemCat]  DEFAULT ('') FOR [ItemCat]
GO
ALTER TABLE [dbo].[BarcodeSplit] ADD  CONSTRAINT [DF_BarcodeSplit_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[BarcodeSplit] ADD  CONSTRAINT [DF_BarcodeSplit_Barcode]  DEFAULT ('') FOR [Barcode]
GO
ALTER TABLE [dbo].[BarcodeSplit] ADD  CONSTRAINT [DF_BarcodeSplit_EAN]  DEFAULT ('') FOR [EAN]
GO
ALTER TABLE [dbo].[BarcodeSplit] ADD  CONSTRAINT [DF_BarcodeSplit_ItemSize]  DEFAULT ('') FOR [ItemSize]
GO
ALTER TABLE [dbo].[BarcodeSplit] ADD  CONSTRAINT [DF_BarcodeSplit_ItemColor]  DEFAULT ('') FOR [ItemColor]
GO
ALTER TABLE [dbo].[BarcodeSplit] ADD  CONSTRAINT [DF_BarcodeSplit_Qty]  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[BarcodeSplit] ADD  CONSTRAINT [DF_BarcodeSplit_Ctns]  DEFAULT ((1)) FOR [Ctns]
GO
ALTER TABLE [dbo].[BarcodeSplit] ADD  CONSTRAINT [DF_BarcodeSplit_SplitDeliveryId]  DEFAULT ('') FOR [SplitDeliveryId]
GO
ALTER TABLE [dbo].[BarcodeSplitDelivery] ADD  CONSTRAINT [DF_BarcodeSplitDelivery_SplitDeliveryId]  DEFAULT ('') FOR [SplitDeliveryId]
GO
ALTER TABLE [dbo].[BarcodeSplitDelivery] ADD  CONSTRAINT [DF_BarcodeSplitDelivery_VesselOrderNo]  DEFAULT ((0)) FOR [VesselOrderNo]
GO
ALTER TABLE [dbo].[BarcodeSplitDelivery] ADD  CONSTRAINT [DF_BarcodeSplitDelivery_VesselName]  DEFAULT ('') FOR [VesselName]
GO
ALTER TABLE [dbo].[BarcodeSplitDelivery] ADD  CONSTRAINT [DF_BarcodeSplitDelivery_VoyageNo]  DEFAULT ('') FOR [VoyageNo]
GO
ALTER TABLE [dbo].[BarcodeSplitDelivery] ADD  CONSTRAINT [DF_BarcodeSplitDelivery_Carrier]  DEFAULT ('') FOR [Carrier]
GO
ALTER TABLE [dbo].[BarcodeSplitDelivery] ADD  CONSTRAINT [DF_BarcodeSplitDelivery_PortCode]  DEFAULT ('') FOR [ShipMode]
GO
ALTER TABLE [dbo].[BarcodeSplitDelivery] ADD  CONSTRAINT [DF_BarcodeSplitDelivery_ContainerOrderNo]  DEFAULT ((0)) FOR [ContainerOrderNo]
GO
ALTER TABLE [dbo].[BarcodeSplitDelivery] ADD  CONSTRAINT [DF_BarcodeSplitDelivery_ContainerType]  DEFAULT ('') FOR [ContainerType]
GO
ALTER TABLE [dbo].[BarcodeSplitDelivery] ADD  CONSTRAINT [DF_BarcodeSplitDelivery_NextContainerNo]  DEFAULT ('') FOR [NextContainerNo]
GO
ALTER TABLE [dbo].[BarcodeSplitDelivery] ADD  CONSTRAINT [DF_BarcodeSplitDelivery_SCMNo]  DEFAULT ('') FOR [SCMNo]
GO
ALTER TABLE [dbo].[BarcodeSplitDelivery] ADD  CONSTRAINT [DF_BarcodeSplitDelivery_VGM]  DEFAULT ((0)) FOR [VGM]
GO
ALTER TABLE [dbo].[BarcodeSplitDelivery] ADD  CONSTRAINT [DF_BarcodeSplitDelivery_SealNo]  DEFAULT ('') FOR [SealNo]
GO
ALTER TABLE [dbo].[BarcodeSplitDelivery] ADD  CONSTRAINT [DF_BarcodeSplitDelivery_ExportType]  DEFAULT ('') FOR [ExportType]
GO
ALTER TABLE [dbo].[BarcodeSplitDeliveryLastId] ADD  CONSTRAINT [DF_BarcodeSplitDeliveryLastId_SplitDeliveryNo]  DEFAULT ((0)) FOR [SplitDeliveryNo]
GO
ALTER TABLE [dbo].[BarcodeSplitDeliveryLastId] ADD  CONSTRAINT [DF_BarcodeSplitDeliveryLastId_SplitDeliveryYear]  DEFAULT ((0)) FOR [SplitDeliveryYear]
GO
ALTER TABLE [dbo].[BlockedDCCountry] ADD  CONSTRAINT [DF_BlockedDCCountry_WhDes]  DEFAULT ('') FOR [WhDes]
GO
ALTER TABLE [dbo].[BlockedDCCountry] ADD  CONSTRAINT [DF_BlockedDCCountry_CountryCode]  DEFAULT ('') FOR [CountryCode]
GO
ALTER TABLE [dbo].[BookingSheetLast] ADD  CONSTRAINT [DF_BookingSheetLast_LastNo]  DEFAULT ((0)) FOR [LastNo]
GO
ALTER TABLE [dbo].[BookingSheetLast] ADD  CONSTRAINT [DF_BookingSheetLast_CreateBy]  DEFAULT ('') FOR [CreateBy]
GO
ALTER TABLE [dbo].[BookingSheetLast] ADD  CONSTRAINT [DF_BookingSheetLast_UpdateBy]  DEFAULT ('') FOR [UpdateBy]
GO
ALTER TABLE [dbo].[BookingSheetLast] ADD  CONSTRAINT [DF_BookingSheetLast_LastVesselNo]  DEFAULT ((0)) FOR [LastVesselNo]
GO
ALTER TABLE [dbo].[BookingStatusDetails] ADD  CONSTRAINT [DF_BookingStatusDetails_Status]  DEFAULT ('') FOR [Status]
GO
ALTER TABLE [dbo].[BookingStatusDetails] ADD  CONSTRAINT [DF_BookingStatusDetails_Reason]  DEFAULT ('') FOR [Reason]
GO
ALTER TABLE [dbo].[BookingStatusDetails] ADD  CONSTRAINT [DF_BookingStatusDetails_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_BarCode]  DEFAULT ('') FOR [BarCode]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_ItemOption]  DEFAULT ('') FOR [ItemOption]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_ILSMismatch]  DEFAULT ('') FOR [ILSMismatch]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_Location]  DEFAULT ('') FOR [Location]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_Status]  DEFAULT ('') FOR [Status]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_QCYes]  DEFAULT ((0)) FOR [QCYes]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_VerificationYes]  DEFAULT ((0)) FOR [VerificationYes]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_RtnNo]  DEFAULT ('') FOR [RtnNo]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_UpNo]  DEFAULT ('') FOR [UpNo]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_BarCodePcs]  DEFAULT ((0)) FOR [BarCodePcs]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_BarCodeGrsWgt]  DEFAULT ((0)) FOR [BarCodeGrsWgt]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_BarCodeNetWgt]  DEFAULT ((0)) FOR [BarCodeNetWgt]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_UpLoadCntrNo]  DEFAULT ('') FOR [UpLoadCntrNo]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_PalletOrderNo]  DEFAULT ((0)) FOR [PalletOrderNo]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_TotalPcs]  DEFAULT ((0)) FOR [TotalPcs]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_PickPcs]  DEFAULT ((0)) FOR [PickPcs]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_ValidatePCS]  DEFAULT ((0)) FOR [ValidatePCS]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_ENA]  DEFAULT ('') FOR [ENA]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_ItemSize]  DEFAULT ('') FOR [ItemSize]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_ItemColor]  DEFAULT ('') FOR [ItemColor]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_ItemDes]  DEFAULT ('') FOR [ItemDes]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_CtnType]  DEFAULT ('') FOR [CtnType]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_CtnLength]  DEFAULT ((0)) FOR [CtnLength]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_CtnWidth]  DEFAULT ((0)) FOR [CtnWidth]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_CtnHeight]  DEFAULT ((0)) FOR [CtnHeight]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_PickPackEnterBy]  DEFAULT ('') FOR [PickPackEnterBy]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_LockPick]  DEFAULT ((0)) FOR [LockPick]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_LockPickBy]  DEFAULT ('') FOR [LockPickBy]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_MismatchPCS]  DEFAULT ((0)) FOR [MismatchPCS]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_TagMissingPCS]  DEFAULT ((0)) FOR [TagMissingPCS]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_ValidateEnterBy]  DEFAULT ('') FOR [ValidateEnterBy]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_SetItem]  DEFAULT ((0)) FOR [SetItem]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_PackPCS]  DEFAULT ((0)) FOR [PackPCS]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_AddBox]  DEFAULT ((0)) FOR [AddBox]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_AddBoxNo]  DEFAULT ((0)) FOR [AddBoxNo]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_BarcodeAudit]  DEFAULT ('') FOR [BarcodeAudit]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_PMStockUpdate]  DEFAULT ('') FOR [PMStockUpdate]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_NofParts]  DEFAULT ((0)) FOR [NofParts]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_NofJokers]  DEFAULT ((0)) FOR [NofJokers]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_RFIDShortage]  DEFAULT ((0)) FOR [RFIDShortage]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_JokerTagsShortage]  DEFAULT ((0)) FOR [JokerTagsShortage]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_FirewallOK]  DEFAULT ((0)) FOR [FirewallOK]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_LPNNo]  DEFAULT ((0)) FOR [LPNBoxNo]
GO
ALTER TABLE [dbo].[CargoBarCode] ADD  CONSTRAINT [DF_CargoBarCode_ExportPalletNo]  DEFAULT ((0)) FOR [ExportPalletNo]
GO
ALTER TABLE [dbo].[CargoBarcodeCtnOut] ADD  CONSTRAINT [DF_CargoBarcodeCtnOut_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[CargoBarcodeCtnOut] ADD  CONSTRAINT [DF_CargoBarcodeCtnOut_BoxId]  DEFAULT ('') FOR [BoxId]
GO
ALTER TABLE [dbo].[CargoBarcodeCtnOut] ADD  CONSTRAINT [DF_CargoBarcodeCtnOut_StoreCode]  DEFAULT ('') FOR [StoreCode]
GO
ALTER TABLE [dbo].[CargoBarcodeCtnOut] ADD  CONSTRAINT [DF_CargoBarcodeCtnOut_ItemOption]  DEFAULT ('') FOR [ItemOption]
GO
ALTER TABLE [dbo].[CargoBarcodeCtnOut] ADD  CONSTRAINT [DF_CargoBarcodeCtnOut_EAN]  DEFAULT ('') FOR [EAN]
GO
ALTER TABLE [dbo].[CargoBarcodeCtnOut] ADD  CONSTRAINT [DF_CargoBarcodeCtnOut_PackQty]  DEFAULT ((0)) FOR [PackQty]
GO
ALTER TABLE [dbo].[CargoBarcodeCtnOut] ADD  CONSTRAINT [DF_CargoBarcodeCtnOut_CtnType]  DEFAULT ('') FOR [CtnType]
GO
ALTER TABLE [dbo].[CargoBarcodeCtnOut] ADD  CONSTRAINT [DF_CargoBarcodeCtnOut_CtnLength]  DEFAULT ((0)) FOR [CtnLength]
GO
ALTER TABLE [dbo].[CargoBarcodeCtnOut] ADD  CONSTRAINT [DF_Table_1_CtnHeight]  DEFAULT ((0)) FOR [CtnWidth]
GO
ALTER TABLE [dbo].[CargoBarcodeCtnOut] ADD  CONSTRAINT [DF_Table_1_CtnWidth]  DEFAULT ((0)) FOR [CtnHeight]
GO
ALTER TABLE [dbo].[CargoBarcodeCtnOut] ADD  CONSTRAINT [DF_CargoBarcodeCtnOut_CtnCBM]  DEFAULT ((0)) FOR [CtnCBM]
GO
ALTER TABLE [dbo].[CargoBarcodeCtnOut] ADD  CONSTRAINT [DF_CargoBarcodeCtnOut_isNewBox]  DEFAULT ((0)) FOR [isNewBox]
GO
ALTER TABLE [dbo].[CargoBarcodeCtnOut] ADD  CONSTRAINT [DF_CargoBarcodeCtnOut_Status]  DEFAULT ('') FOR [Status]
GO
ALTER TABLE [dbo].[CargoBarcodeCtnOutInDtl] ADD  CONSTRAINT [DF_CargoBarcodeCtnOutInDtl_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[CargoBarcodeCtnOutInDtl] ADD  CONSTRAINT [DF_CargoBarcodeCtnOutInDtl_BoxId]  DEFAULT ('') FOR [BoxId]
GO
ALTER TABLE [dbo].[CargoBarcodeCtnOutInDtl] ADD  CONSTRAINT [DF_CargoBarcodeCtnOutInDtl_BoxScanManual]  DEFAULT ('') FOR [BoxScanManual]
GO
ALTER TABLE [dbo].[CargoBarcodeCtnOutInDtl] ADD  CONSTRAINT [DF_CargoBarcodeCtnOutInDtl_BarCode]  DEFAULT ('') FOR [BarCode]
GO
ALTER TABLE [dbo].[CargoBarcodeCtnOutInDtl] ADD  CONSTRAINT [DF_CargoBarcodeCtnOutInDtl_PackQty]  DEFAULT ((0)) FOR [PackQty]
GO
ALTER TABLE [dbo].[CargoBarcodeFirewallErrors] ADD  CONSTRAINT [DF_CargoBarcodeFirewallErrors_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[CargoBarcodeFirewallErrors] ADD  CONSTRAINT [DF_CargoBarcodeFirewallErrors_BoxScanManual]  DEFAULT ('') FOR [BoxScanManual]
GO
ALTER TABLE [dbo].[CargoBarcodeFirewallErrors] ADD  CONSTRAINT [DF_CargoBarcodeFirewallErrors_Barcode]  DEFAULT ('') FOR [Barcode]
GO
ALTER TABLE [dbo].[CargoBarcodeFirewallErrors] ADD  CONSTRAINT [DF_CargoBarcodeFirewallErrors_ErrorType]  DEFAULT ('') FOR [ErrorType]
GO
ALTER TABLE [dbo].[CargoBarcodePMUsage] ADD  CONSTRAINT [DF_CargoBarcodeHangerUsage_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[CargoBarcodePMUsage] ADD  CONSTRAINT [DF_CargoBarcodeHangerUsage_BoxScanManual]  DEFAULT ('S') FOR [BoxScanManual]
GO
ALTER TABLE [dbo].[CargoBarcodePMUsage] ADD  CONSTRAINT [DF_CargoBarcodeHangerUsage_Barcode]  DEFAULT ('') FOR [Barcode]
GO
ALTER TABLE [dbo].[CargoBarcodePMUsage] ADD  CONSTRAINT [DF_CargoBarcodeHangerUsage_HangerType]  DEFAULT ('') FOR [PMCode]
GO
ALTER TABLE [dbo].[CargoBarcodePMUsage] ADD  CONSTRAINT [DF_CargoBarcodeHangerUsage_NofHangers]  DEFAULT ((0)) FOR [PMQty]
GO
ALTER TABLE [dbo].[CargoBarcodePMUsage] ADD  CONSTRAINT [DF_CargoBarcodePMUsage_EntryPoint]  DEFAULT ('') FOR [EntryPoint]
GO
ALTER TABLE [dbo].[CargoBarcodePMUsage] ADD  CONSTRAINT [DF_CargoBarcodePMUsage_Verified]  DEFAULT ((0)) FOR [Verified]
GO
ALTER TABLE [dbo].[CargoBarcodePMUsage] ADD  CONSTRAINT [DF_CargoBarcodePMUsage_UpdatedBy]  DEFAULT ('') FOR [UpdatedBy]
GO
ALTER TABLE [dbo].[CargoBarcodePMUsageContainer] ADD  CONSTRAINT [DF_CargoBarcodePMUsageContainer_BookingDate]  DEFAULT ('') FOR [BookingDate]
GO
ALTER TABLE [dbo].[CargoBarcodePMUsageContainer] ADD  CONSTRAINT [DF_CargoBarcodePMUsageContainer_VesselOrderNumber]  DEFAULT ((0)) FOR [VesselOrderNumber]
GO
ALTER TABLE [dbo].[CargoBarcodePMUsageContainer] ADD  CONSTRAINT [DF_CargoBarcodePMUsageContainer_ContainerOrderNumber]  DEFAULT ((0)) FOR [ContainerOrderNumber]
GO
ALTER TABLE [dbo].[CargoBarcodePMUsageContainer] ADD  CONSTRAINT [DF_CargoBarcodePMUsageContainer_PMCode]  DEFAULT ('') FOR [PMCode]
GO
ALTER TABLE [dbo].[CargoBarcodePMUsageContainer] ADD  CONSTRAINT [DF_CargoBarcodePMUsageContainer_PMQty]  DEFAULT ((0)) FOR [PMQty]
GO
ALTER TABLE [dbo].[CargoBarcodePMUsageContainer] ADD  CONSTRAINT [DF_CargoBarcodePMUsageContainer_EntryPoint]  DEFAULT ('CT') FOR [EntryPoint]
GO
ALTER TABLE [dbo].[CargoBarcodePMUsageContainer] ADD  CONSTRAINT [DF_CargoBarcodePMUsageContainer_Verified]  DEFAULT ((1)) FOR [Verified]
GO
ALTER TABLE [dbo].[CargoBarcodePMUsageContainer] ADD  CONSTRAINT [DF_CargoBarcodePMUsageContainer_UpdatedBy]  DEFAULT ('') FOR [UpdatedBy]
GO
ALTER TABLE [dbo].[CargoDueFlowup] ADD  CONSTRAINT [DF_CargoDueFlowup_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[CargoDueFlowup] ADD  CONSTRAINT [DF_CargoDueFlowup_DueTask]  DEFAULT ('R') FOR [DueTask]
GO
ALTER TABLE [dbo].[CargoDueFlowup] ADD  CONSTRAINT [DF_CargoDueFlowup_NofFlowUp]  DEFAULT ((0)) FOR [NofFlowUp]
GO
ALTER TABLE [dbo].[CargoDueFlowUpDtl] ADD  CONSTRAINT [DF_CargoDueFlowUpDtl_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[CargoDueFlowUpDtl] ADD  CONSTRAINT [DF_CargoDueFlowUpDtl_DueTask]  DEFAULT ('') FOR [DueTask]
GO
ALTER TABLE [dbo].[CargoDueFlowUpDtl] ADD  CONSTRAINT [DF_CargoDueFlowUpDtl_ResonId]  DEFAULT ((0)) FOR [ReasonId]
GO
ALTER TABLE [dbo].[CargoDueResons] ADD  CONSTRAINT [DF_ReworkDueResons_DesDes]  DEFAULT ('') FOR [DueDes]
GO
ALTER TABLE [dbo].[CargoDueResons] ADD  CONSTRAINT [DF_CargoDueResons_DueTask]  DEFAULT ('') FOR [DueTask]
GO
ALTER TABLE [dbo].[CargoItemOption] ADD  CONSTRAINT [DF_CargoItemOption_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[CargoItemOption] ADD  CONSTRAINT [DF_CargoItemOption_ItemOption]  DEFAULT ('') FOR [ItemOption]
GO
ALTER TABLE [dbo].[CargoItemOption] ADD  CONSTRAINT [DF_CargoItemOption_OptionSize]  DEFAULT ('') FOR [OptionSize]
GO
ALTER TABLE [dbo].[CargoItemOption] ADD  CONSTRAINT [DF_CargoItemOption_Ctns]  DEFAULT ((0)) FOR [Ctns]
GO
ALTER TABLE [dbo].[CargoItemOption] ADD  CONSTRAINT [DF_CargoItemOption_PCS]  DEFAULT ((0)) FOR [PCS]
GO
ALTER TABLE [dbo].[CargoItemOption] ADD  CONSTRAINT [DF_CargoItemOption_ItemOptionJMB]  DEFAULT ('') FOR [ItemOptionJMB]
GO
ALTER TABLE [dbo].[CargoItemOption] ADD  CONSTRAINT [DF_CargoItemOption_CtnType]  DEFAULT ('') FOR [CtnType]
GO
ALTER TABLE [dbo].[CargoItemOptionRFID] ADD  CONSTRAINT [DF_CargoItemOptionRFID_ContractNo]  DEFAULT ('') FOR [ContractNo]
GO
ALTER TABLE [dbo].[CargoItemOptionRFID] ADD  CONSTRAINT [DF_CargoItemOptionRFID_DeliveryNo]  DEFAULT ((0)) FOR [DeliveryNo]
GO
ALTER TABLE [dbo].[CargoItemOptionRFID] ADD  CONSTRAINT [DF_CargoItemOptionRFID_ItemOption]  DEFAULT ('') FOR [ItemOption]
GO
ALTER TABLE [dbo].[CargoItemOptionRFID] ADD  CONSTRAINT [DF_CargoItemOptionRFID_OptionSize]  DEFAULT ('') FOR [OptionSize]
GO
ALTER TABLE [dbo].[CargoItemOptionRFID] ADD  CONSTRAINT [DF_CargoItemOptionRFID_PCS]  DEFAULT ((0)) FOR [PCS]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_CtnNo]  DEFAULT ((0)) FOR [CtnNo]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_BarCode]  DEFAULT ('') FOR [BarCode]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_ItemOption]  DEFAULT ('') FOR [ItemOption]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_TotalPcs]  DEFAULT ((0)) FOR [TotalPcs]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_PickPcs]  DEFAULT ((0)) FOR [PickPcs]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_ENA]  DEFAULT ('') FOR [ENA]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_ItemSize]  DEFAULT ('') FOR [ItemSize]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_ItemColor]  DEFAULT ('') FOR [ItemColor]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_ItemDes]  DEFAULT ('') FOR [ItemDes]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_PickPackEnterBy]  DEFAULT ('') FOR [PickPackEnterBy]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_MismatchPCS]  DEFAULT ((0)) FOR [MismatchPCS]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_TagMissingPCS]  DEFAULT ((0)) FOR [TagMissingPCS]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_ValidatePCS]  DEFAULT ((0)) FOR [ValidatePCS]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_ValidateEnterBy]  DEFAULT ('') FOR [ValidateEnterBy]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_SetItem]  DEFAULT ((0)) FOR [SetItem]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_PackPCS]  DEFAULT ((0)) FOR [PackPCS]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_AddBox]  DEFAULT ((0)) FOR [AddBox]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_AddBoxNo]  DEFAULT ((0)) FOR [AddBoxNo]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_NofParts]  DEFAULT ((0)) FOR [NofParts]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_NofJokers]  DEFAULT ((0)) FOR [NofJokers]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_RFIDShortage]  DEFAULT ((0)) FOR [RFIDShortage]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_JokerTagsShortage]  DEFAULT ((0)) FOR [JokerTagsShortage]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_FirewallOk]  DEFAULT ((0)) FOR [FirewallOk]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_BarcodeAudit]  DEFAULT ('') FOR [BarcodeAudit]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_LPNNo]  DEFAULT ((0)) FOR [LPNBoxNo]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_CtnLength]  DEFAULT ((0)) FOR [CtnLength]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_CtnWidth]  DEFAULT ((0)) FOR [CtnWidth]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_CtnHeight]  DEFAULT ((0)) FOR [CtnHeight]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_Status]  DEFAULT ('') FOR [Status]
GO
ALTER TABLE [dbo].[CargoManualBox] ADD  CONSTRAINT [DF_CargoManualBox_ExportPalletNo]  DEFAULT ((0)) FOR [ExportPalletNo]
GO
ALTER TABLE [dbo].[CargoPalletLoading] ADD  CONSTRAINT [DF_CargoPalletLoading_VesselOrderNo_1]  DEFAULT ((0)) FOR [VesselOrderNo]
GO
ALTER TABLE [dbo].[CargoPalletLoading] ADD  CONSTRAINT [DF_CargoPalletLoading_ContainerOrderNo_1]  DEFAULT ((0)) FOR [ContainerOrderNo]
GO
ALTER TABLE [dbo].[CargoPalletLoading] ADD  CONSTRAINT [DF_CargoPalletLoading_PalletNo_1]  DEFAULT ((0)) FOR [PalletNo]
GO
ALTER TABLE [dbo].[CargoPalletLoading] ADD  CONSTRAINT [DF_CargoPalletLoading_IsClosed]  DEFAULT ((0)) FOR [IsClosed]
GO
ALTER TABLE [dbo].[CargoPallets] ADD  CONSTRAINT [DF_CargoPallets_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[CargoPallets] ADD  CONSTRAINT [DF_CargoPallets_PalletOrderNo]  DEFAULT ((0)) FOR [PalletOrderNo]
GO
ALTER TABLE [dbo].[CargoPallets] ADD  CONSTRAINT [DF_CargoPallets_PalletType]  DEFAULT ('') FOR [PalletType]
GO
ALTER TABLE [dbo].[CargoPallets] ADD  CONSTRAINT [DF_CargoPallets_PalletNo]  DEFAULT ('') FOR [PalletNo]
GO
ALTER TABLE [dbo].[CargoPallets] ADD  CONSTRAINT [DF_CargoPallets_UnitsLoad]  DEFAULT ((0)) FOR [UnitsLoad]
GO
ALTER TABLE [dbo].[CargoPallets] ADD  CONSTRAINT [DF_CargoPallets_PalletLocation]  DEFAULT ('') FOR [PalletLocation]
GO
ALTER TABLE [dbo].[CargoPallets] ADD  CONSTRAINT [DF_CargoPallets_PalletQC]  DEFAULT ((0)) FOR [PalletQC]
GO
ALTER TABLE [dbo].[CargoPics] ADD  CONSTRAINT [DF_CargoPics_PicEvent]  DEFAULT ('') FOR [PicEvent]
GO
ALTER TABLE [dbo].[CargoPics] ADD  CONSTRAINT [DF_CargoPics_GrnNo]  DEFAULT ('') FOR [GrnNo]
GO
ALTER TABLE [dbo].[CargoPics] ADD  CONSTRAINT [DF_CargoPics_VesselOrderNo]  DEFAULT ((0)) FOR [VesselOrderNo]
GO
ALTER TABLE [dbo].[CargoPics] ADD  CONSTRAINT [DF_CargoPics_ContainerOrderNo]  DEFAULT ((0)) FOR [ContainerOrderNo]
GO
ALTER TABLE [dbo].[CargoPics] ADD  CONSTRAINT [DF_CargoPics_BookingNo]  DEFAULT ('') FOR [BookingNo]
GO
ALTER TABLE [dbo].[CargoPics] ADD  CONSTRAINT [DF_CargoPics_OuterBarcode]  DEFAULT ('') FOR [OuterBarcode]
GO
ALTER TABLE [dbo].[CargoPics] ADD  CONSTRAINT [DF_CargoPics_FileName]  DEFAULT ('') FOR [PicFileName]
GO
ALTER TABLE [dbo].[CargoPics] ADD  CONSTRAINT [DF_CargoPics_FileFullPath]  DEFAULT ('') FOR [PicFileFullPath]
GO
ALTER TABLE [dbo].[CargoQC] ADD  CONSTRAINT [DF_CargoQC_RcvNo]  DEFAULT ((0)) FOR [RcvNo]
GO
ALTER TABLE [dbo].[CargoQC] ADD  CONSTRAINT [DF_CargoQC_OrderNo]  DEFAULT ((0)) FOR [OrderNo]
GO
ALTER TABLE [dbo].[CargoQC] ADD  CONSTRAINT [DF_CargoQC_QCResult]  DEFAULT ('') FOR [QCResult]
GO
ALTER TABLE [dbo].[CargoQC] ADD  CONSTRAINT [DF_CargoQC_QCRemark]  DEFAULT ('') FOR [QCRemark]
GO
ALTER TABLE [dbo].[CargoQC] ADD  CONSTRAINT [DF_CargoQC_QCBy]  DEFAULT ('') FOR [QCBy]
GO
ALTER TABLE [dbo].[CargoQC] ADD  CONSTRAINT [DF_CargoQC_UpdateBy]  DEFAULT ('') FOR [UpdateBy]
GO
ALTER TABLE [dbo].[CargoQC] ADD  CONSTRAINT [DF_CargoQC_QCShippingMode]  DEFAULT ('') FOR [QCShippingMode]
GO
ALTER TABLE [dbo].[CargoQC] ADD  CONSTRAINT [DF_CargoQC_Final]  DEFAULT ((0)) FOR [Final]
GO
ALTER TABLE [dbo].[CargoRatioPack] ADD  CONSTRAINT [DF_CargoRatioPack_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[CargoRatioPack] ADD  CONSTRAINT [DF_CargoRatioPack_BoxId]  DEFAULT ('') FOR [BoxId]
GO
ALTER TABLE [dbo].[CargoRatioPack] ADD  CONSTRAINT [DF_CargoRatioPack_RatioPackNo]  DEFAULT ((0)) FOR [RatioPackNo]
GO
ALTER TABLE [dbo].[CargoRatioPack] ADD  CONSTRAINT [DF_CargoRatioPack_NofSets]  DEFAULT ((0)) FOR [NofSets]
GO
ALTER TABLE [dbo].[CargoRatioPackPlan] ADD  CONSTRAINT [DF_CargoRatioPackPlan_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[CargoRatioPackPlan] ADD  CONSTRAINT [DF_CargoRatioPackPlan_RatioPackNo]  DEFAULT ((0)) FOR [RatioPackNo]
GO
ALTER TABLE [dbo].[CargoRatioPackPlan] ADD  CONSTRAINT [DF_CargoRatioPackPlan_NofSets]  DEFAULT ((0)) FOR [NofSets]
GO
ALTER TABLE [dbo].[CargoRatioPackPlan] ADD  CONSTRAINT [DF_CargoRatioPackPlan_PcsPerSet]  DEFAULT ((0)) FOR [PcsPerSet]
GO
ALTER TABLE [dbo].[CargoRatioPackPlan] ADD  CONSTRAINT [DF_CargoRatioPackPlan_NofSetsPending]  DEFAULT ((0)) FOR [NofSetsPending]
GO
ALTER TABLE [dbo].[CargoRatioPackPlanDtl] ADD  CONSTRAINT [DF_CargoRatioPackPlanDtl_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[CargoRatioPackPlanDtl] ADD  CONSTRAINT [DF_CargoRatioPackPlanDtl_RatioPackNo]  DEFAULT ((0)) FOR [RatioPackNo]
GO
ALTER TABLE [dbo].[CargoRatioPackPlanDtl] ADD  CONSTRAINT [DF_CargoRatioPackPlanDtl_ItemOption]  DEFAULT ('') FOR [ItemOption]
GO
ALTER TABLE [dbo].[CargoRatioPackPlanDtl] ADD  CONSTRAINT [DF_CargoRatioPackPlanDtl_NofOfPcs]  DEFAULT ((0)) FOR [NofOfPcs]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_InboundBookingType]  DEFAULT ('') FOR [InboundBookingType]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_CargoFrom]  DEFAULT ('') FOR [CargoFrom]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_InboundVesselOrderNo]  DEFAULT ((0)) FOR [InboundVesselOrderNo]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_InboundCntrOrderNo]  DEFAULT ((0)) FOR [InboundContainerOrderNo]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_EntryType]  DEFAULT ('Scan') FOR [EntryType]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ConfirmArriveStatus]  DEFAULT ('') FOR [ConfirmArriveStatus]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ConfirmArriveBy]  DEFAULT ('') FOR [ConfirmArriveBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_TaskStatus]  DEFAULT ('') FOR [StatusCode]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_BookingStatus]  DEFAULT ('') FOR [BookingStatus]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_BookingStatusBy]  DEFAULT ('') FOR [BookingStatusBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ShCode]  DEFAULT ('') FOR [ShipperCode]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ContractNo]  DEFAULT ('') FOR [ContractNo]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ItemNo]  DEFAULT ('') FOR [ItemNo]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ItemCategory]  DEFAULT ('') FOR [ItemCategory]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_InvoiceNo]  DEFAULT ('') FOR [InvoiceNo]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_PONo]  DEFAULT ('') FOR [PONo]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_DeliveryNo]  DEFAULT ((0)) FOR [DeliveryNo]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ShippingMode]  DEFAULT ('') FOR [ShippingMode]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_PackType]  DEFAULT ('') FOR [CargoType]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_Ctns]  DEFAULT ((0)) FOR [Ctns]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_PCS]  DEFAULT ((0)) FOR [PCS]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ScanQty1]  DEFAULT ((0)) FOR [ScanQty]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_CBM]  DEFAULT ((0)) FOR [CBM]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_GrossWgt]  DEFAULT ((0)) FOR [GrossWgt]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_NofBar]  DEFAULT ((0)) FOR [NofBar]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_LorryNo]  DEFAULT ('') FOR [LorryNo]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_IntakeComments]  DEFAULT ('') FOR [IntakeComments]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_WHLocation]  DEFAULT ('') FOR [WHLocation]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_TradeLane]  DEFAULT ('') FOR [TradeLane]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_Country]  DEFAULT ('') FOR [Country]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_Warehouse]  DEFAULT ('') FOR [Warehouse]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_QCType]  DEFAULT ('') FOR [QCType]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_QCYes]  DEFAULT ('') FOR [QCYes]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_EnterBy]  DEFAULT ('') FOR [EnterBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_QCStats]  DEFAULT ('') FOR [QCStatus]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_QCDone]  DEFAULT ((0)) FOR [QCDone]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_QCResult]  DEFAULT ('') FOR [QCResult]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_QCDoneBy]  DEFAULT ('') FOR [QCDoneBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_QCRemarks]  DEFAULT ('') FOR [QCRemarks]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_LimaValidate]  DEFAULT ((0)) FOR [LimaValidate]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_Authorized]  DEFAULT ((0)) FOR [Authorized]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_DC]  DEFAULT ('') FOR [DC]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_AirCost]  DEFAULT ('') FOR [AirCost]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_NextToPay]  DEFAULT ((0)) FOR [NextToPay]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_PackListUpdate]  DEFAULT ((0)) FOR [PackListUpdate]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_PackListUpdateBy]  DEFAULT ('') FOR [PackListUpdateBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_Verification]  DEFAULT ((0)) FOR [Verification]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_VerificationBy]  DEFAULT ('') FOR [VerificationBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_RemoveStatus]  DEFAULT ('') FOR [RemoveStatus]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_RemoveReference]  DEFAULT ('') FOR [RemoveReference]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_RemoveStatusDoneBy]  DEFAULT ('') FOR [RemoveStatusDoneBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_RemoveDoneBy]  DEFAULT ('') FOR [RemoveDoneBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_RemoveType]  DEFAULT ('') FOR [RemoveType]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_RemovalComments]  DEFAULT ('') FOR [RemovalComments]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ReWorkQty]  DEFAULT ((0)) FOR [ReWorkQty]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_InPCS]  DEFAULT ((0)) FOR [InPCS]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_PackPCS]  DEFAULT ((0)) FOR [PackPCS]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_InQty]  DEFAULT ((0)) FOR [InQty]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_PackQty]  DEFAULT ((0)) FOR [PackQty]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_RemoveQty]  DEFAULT ((0)) FOR [RemoveQty]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_QCStaff]  DEFAULT ('') FOR [QCStaffCode]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_LoadNo]  DEFAULT ('') FOR [LoadNo]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_VesselOrderNo]  DEFAULT ((0)) FOR [VesselOrderNo]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ContainerOrderNo]  DEFAULT ((0)) FOR [ContainerOrderNo]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_LoadPosition]  DEFAULT ((0)) FOR [LoadPosition]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ContainerLoadOrder]  DEFAULT ((0)) FOR [LimaPosition]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_LoadingRef]  DEFAULT ('') FOR [LoadingRef]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_LoadingRefChangeBy]  DEFAULT ('') FOR [LoadingRefChangeBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_TailEnd]  DEFAULT ((0)) FOR [TailEnd]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ShippingModeIn]  DEFAULT ('') FOR [ShippingModeIn]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_PCSIn]  DEFAULT ((0)) FOR [PCSIn]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_CtnsIn]  DEFAULT ((0)) FOR [CtnsIn]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_CBMIn]  DEFAULT ((0)) FOR [CBMIn]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_DeliveryNoIn]  DEFAULT ((0)) FOR [DeliveryNoIn]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ShipmentTypeIn]  DEFAULT ('') FOR [TradeLaneIn]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_FrCountryIn]  DEFAULT ('') FOR [CountryIn]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_RemoveQtyPart]  DEFAULT ((0)) FOR [RemovePartQty]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_RemovePCSPart]  DEFAULT ((0)) FOR [RemovePartPCS]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_RemoveCMBPart]  DEFAULT ((0)) FOR [RemovePartCBM]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_RemoveQtyPartScan]  DEFAULT ((0)) FOR [RemoveQtyPartScan]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_RemovePartBy]  DEFAULT ('') FOR [RemovePartBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_RemovePartQtyRemark]  DEFAULT ('') FOR [RemovePartQtyRemark]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_UpdateBy]  DEFAULT ('') FOR [UpdateBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_SplitJobNo]  DEFAULT ('') FOR [SplitRcvNo]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_isManualIn]  DEFAULT ((0)) FOR [isManualIn]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_isManualOut]  DEFAULT ((0)) FOR [isManualOut]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_LoadType]  DEFAULT ('') FOR [LoadType]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_LorryNoLoad]  DEFAULT ('') FOR [LorryNoLoad]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_OutBy]  DEFAULT ('') FOR [OutBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_OldShippingMode]  DEFAULT (' ') FOR [OldShippingMode]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_OldAirCost]  DEFAULT ('') FOR [OldAirCost]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ModeChangeBy]  DEFAULT (' ') FOR [ModeChangeBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ShippingModeQC]  DEFAULT ('') FOR [ShippingModeQC]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_DeliveryNoQC]  DEFAULT ((0)) FOR [DeliveryNoQC]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_TradeLaneQC]  DEFAULT ('') FOR [TradeLaneQC]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_CountryQC]  DEFAULT ('') FOR [CountryQC]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_QCCtns]  DEFAULT ((0)) FOR [QCCtns]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_QCPcs]  DEFAULT ((0)) FOR [QCPcs]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_QCPcsReject]  DEFAULT ((0)) FOR [QCPcsReject]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_DescrepancyRemark]  DEFAULT ('') FOR [Descrepancy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_DescrepancyOK]  DEFAULT ((0)) FOR [DescrepancyOK]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_DescrepancyBy]  DEFAULT ('') FOR [DescrepancyBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_QCQty]  DEFAULT ((0)) FOR [QCQty]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_VerifyQty]  DEFAULT ((0)) FOR [VerifyQty]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_InputChecked]  DEFAULT ((0)) FOR [InChecked]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_InCheckedComment]  DEFAULT ('') FOR [InCheckedComment]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_InputCheckedBy]  DEFAULT ('') FOR [InCheckedBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_UpLiftStatus]  DEFAULT ('') FOR [UpLiftStatus]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_UpLiftBy]  DEFAULT ('') FOR [UpLiftBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_LoadCancelStatus]  DEFAULT ('') FOR [LoadCancelStatus]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_LoadCancelBy]  DEFAULT ('') FOR [LoadCancelBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_LoadCancelQty]  DEFAULT ((0)) FOR [LoadCancelQty]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_DirectMark]  DEFAULT ((0)) FOR [DirectMark]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_DirectMarkBy]  DEFAULT ('') FOR [DirectMarkBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_QCComments]  DEFAULT ('') FOR [QCComments]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_SubJobNo]  DEFAULT ('') FOR [SubJobNo]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_SubJobNoEnterBy]  DEFAULT ('') FOR [SubJobNoEnterBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_QCIn]  DEFAULT ((0)) FOR [QCIn]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_QCInBy]  DEFAULT ('') FOR [QCInBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_QCInCheckBack]  DEFAULT ((0)) FOR [QCInCheckBack]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_QCInCheckBackBy]  DEFAULT ('') FOR [QCInCheckBackBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_InternalReworkRemark]  DEFAULT ('') FOR [InternalReworkRemark]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_InternalReworkDoneBy]  DEFAULT ('') FOR [InternalReworkDoneBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_GRNNo]  DEFAULT ('') FOR [GRNNo]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_IntakeStatus]  DEFAULT ('') FOR [IntakeStatus]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_IntakeStatusBy]  DEFAULT ('') FOR [IntakeStatusBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_PackListYes]  DEFAULT ('') FOR [PackListYes]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_CDNYes]  DEFAULT ('') FOR [CDNYes]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_CusDecYes]  DEFAULT ('') FOR [CusDecYes]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_LorryContactName]  DEFAULT ('') FOR [LorryContactName]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_LorryContactNo]  DEFAULT ('') FOR [LorryContactNo]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_UnloadStatus]  DEFAULT ('') FOR [UnloadStatus]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_UnloadBy]  DEFAULT ('') FOR [UnloadBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_PickENADataStatus]  DEFAULT ('') FOR [PickENADataStatus]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_PickENADataBy]  DEFAULT ('') FOR [PickENADataBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_PickPackQty]  DEFAULT ((0)) FOR [PickPackQty]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_PickPackStatus]  DEFAULT ('') FOR [PickPackStatus]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_PickPackStatusBy]  DEFAULT ('') FOR [PickPackStatusBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_LoadingType]  DEFAULT ('CFS') FOR [LoadingType]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_CustomerRefNo]  DEFAULT ('') FOR [CustomerRefNo]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_LockUnload]  DEFAULT ((0)) FOR [LockUnload]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_LockUnloadBy]  DEFAULT ('') FOR [LockUnloadBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_LockLoading]  DEFAULT ((0)) FOR [LockLoading]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_LockLoadingBy]  DEFAULT ('') FOR [LockLoadingBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_CargoQuality]  DEFAULT ('') FOR [CargoQuality]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_PickQtyAllowMismatch]  DEFAULT ((0)) FOR [PickQtyAllowMismatch]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ManualPCS]  DEFAULT ((0)) FOR [TagMissingPCS]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_PickQtyAllowTagMissing]  DEFAULT ((0)) FOR [PickQtyAllowTagMissing]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_SizeMismatchPCS]  DEFAULT ((0)) FOR [SizeMismatchPCS]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_DamageCtns]  DEFAULT ((0)) FOR [DamageCtns]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_SCMNo]  DEFAULT ('') FOR [SCMNo]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ReachedDest]  DEFAULT ((0)) FOR [ReachedDest]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ApprvRcvStatus_1]  DEFAULT ('') FOR [ApprvReqStatus]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ApprvReqBy_1]  DEFAULT ('') FOR [ApprvReqBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ApprvReqStatus]  DEFAULT ('') FOR [ApprvToShip]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ApprvReqBy]  DEFAULT ('') FOR [ApprvToShipBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ApprvRcvStatus]  DEFAULT ('') FOR [nApprvToShip]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ApprvRcvBy]  DEFAULT ('') FOR [nApprvToShipBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_WarehouseIn]  DEFAULT ('') FOR [WarehouseIn]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_nApprvToShipAction]  DEFAULT ('') FOR [nApprvToShipAction]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_nApprvToShipActionBy]  DEFAULT ('') FOR [nApprvToShipActionBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ItemOptionLookup]  DEFAULT ('') FOR [ItemOptionLookup]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_CusDecNo]  DEFAULT ('') FOR [CusDecNo]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_PCSValidationStatus]  DEFAULT ('') FOR [PCSValidationStatus]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_PCSValidationStatusBy]  DEFAULT ('') FOR [PCSValidationStatusBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_PCSValidateCount]  DEFAULT ((0)) FOR [PCSValidateCount]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_ValidateQty]  DEFAULT ((0)) FOR [ValidateQty]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_OutCBM]  DEFAULT ((0)) FOR [PackCBM]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_OutWgt]  DEFAULT ((0)) FOR [PackWgt]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_DropNo]  DEFAULT ('') FOR [DropNo]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_FirewallStatus]  DEFAULT ('') FOR [FirewallStatus]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_FirewallStatusBy]  DEFAULT ('') FOR [FirewallStatusBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_FirewallQty]  DEFAULT ((0)) FOR [FirewallQty]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_LastPackBoxNo]  DEFAULT ((0)) FOR [LastPackBoxNo]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_HoldStatus]  DEFAULT ('') FOR [HoldStatus]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_HoldReason]  DEFAULT ('') FOR [HoldReason]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_StorePickStatus]  DEFAULT ('') FOR [StorePickStatus]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_StorePickSttusBy]  DEFAULT ('') FOR [StorePickStausBy]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_RfidOrder]  DEFAULT ('') FOR [RfidOrder]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_TotalPlatformPartner]  DEFAULT ('') FOR [TotalPlatformPartner]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_SplittedCtns]  DEFAULT ((0)) FOR [SplittedCtns]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_DivertLocation]  DEFAULT ('') FOR [DivertLocation]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_Comment]  DEFAULT ('') FOR [Comment]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_nofParts]  DEFAULT ((0)) FOR [nofParts]
GO
ALTER TABLE [dbo].[CargoReceived] ADD  CONSTRAINT [DF_CargoReceived_NofSwingticket]  DEFAULT ((0)) FOR [NofSwingticket]
GO
ALTER TABLE [dbo].[CargoReceivedDtl] ADD  CONSTRAINT [DF_CargoReceivedDtl_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[CargoReceivedDtl] ADD  CONSTRAINT [DF_CargoReceivedDtl_Description]  DEFAULT ('') FOR [Description]
GO
ALTER TABLE [dbo].[CargoReceivedDtl] ADD  CONSTRAINT [DF_CargoReceivedDtl_NofCtn]  DEFAULT ((0)) FOR [NofCtn]
GO
ALTER TABLE [dbo].[CargoReceivedDtl] ADD  CONSTRAINT [DF_CargoReceivedDtl_NofPcs]  DEFAULT ((0)) FOR [NofPcs]
GO
ALTER TABLE [dbo].[CargoReceivedDtl] ADD  CONSTRAINT [DF_CargoReceivedDtl_TotGrsWgt]  DEFAULT ((0)) FOR [TotGrsWgt]
GO
ALTER TABLE [dbo].[CargoReceivedDtl] ADD  CONSTRAINT [DF_CargoReceivedDtl_TotNetWgt]  DEFAULT ((0)) FOR [TotNetWgt]
GO
ALTER TABLE [dbo].[CargoReturn] ADD  CONSTRAINT [DF_CargoReturn_RtnNo]  DEFAULT ('') FOR [RtnNo]
GO
ALTER TABLE [dbo].[CargoReturn] ADD  CONSTRAINT [DF_CargoReturn_LorryNo]  DEFAULT ('') FOR [LorryNo]
GO
ALTER TABLE [dbo].[CargoReturn] ADD  CONSTRAINT [DF_CargoReturn_RtnCtns]  DEFAULT ((0)) FOR [RtnCtns]
GO
ALTER TABLE [dbo].[CargoReturn] ADD  CONSTRAINT [DF_CargoReturn_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[CargoStorePickPlan] ADD  CONSTRAINT [DF_CargoStorePickPlan_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[CargoStorePickPlan] ADD  CONSTRAINT [DF_CargoStorePickPlan_ItemOption]  DEFAULT ('') FOR [ItemOption]
GO
ALTER TABLE [dbo].[CargoStorePickPlan] ADD  CONSTRAINT [DF_CargoStorePickPlan_StoreCode]  DEFAULT ('') FOR [StoreCode]
GO
ALTER TABLE [dbo].[CargoStorePickPlan] ADD  CONSTRAINT [DF_CargoStorePickPlan_QtyPlan]  DEFAULT ((0)) FOR [PickPlanQty]
GO
ALTER TABLE [dbo].[CargoStorePickPlan] ADD  CONSTRAINT [DF_CargoStorePickPlan_QtyLoad]  DEFAULT ((0)) FOR [PickedQty]
GO
ALTER TABLE [dbo].[CargoUpload] ADD  CONSTRAINT [DF_CargoUpload_UpdNo]  DEFAULT ('') FOR [UpdNo]
GO
ALTER TABLE [dbo].[CargoUpload] ADD  CONSTRAINT [DF_CargoUpload_ShipperCode]  DEFAULT ('') FOR [ShipperCode]
GO
ALTER TABLE [dbo].[CargoUpload] ADD  CONSTRAINT [DF_CargoUpload_LorryNo]  DEFAULT ('') FOR [LorryNo]
GO
ALTER TABLE [dbo].[CargoUpload] ADD  CONSTRAINT [DF_CargoUpload_JobNo]  DEFAULT ('') FOR [JobNo]
GO
ALTER TABLE [dbo].[CargoUpload] ADD  CONSTRAINT [DF_CargoUpload_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[CargoUpload] ADD  CONSTRAINT [DF_CargoUpload_UpdCtns]  DEFAULT ((0)) FOR [UpdCtns]
GO
ALTER TABLE [dbo].[CargoUpload] ADD  CONSTRAINT [DF_CargoUpload_LoadRef]  DEFAULT ('') FOR [LoadRef]
GO
ALTER TABLE [dbo].[CargoUpload] ADD  CONSTRAINT [DF_CargoUpload_LoadBy]  DEFAULT ('') FOR [LoadBy]
GO
ALTER TABLE [dbo].[CargoUpload] ADD  CONSTRAINT [DF_CargoUpload_LoadFinish]  DEFAULT ((0)) FOR [LoadFinish]
GO
ALTER TABLE [dbo].[CargoUploadDtl] ADD  CONSTRAINT [DF_CargoUploadDtl_UpdNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[CargoUploadDtl] ADD  CONSTRAINT [DF_CargoUploadDtl_OrderNo]  DEFAULT ((0)) FOR [ContainerOrderNo_]
GO
ALTER TABLE [dbo].[CargoUploadDtl] ADD  CONSTRAINT [DF_CargoUploadDtl_NofCtn]  DEFAULT ((0)) FOR [Row1]
GO
ALTER TABLE [dbo].[CargoUploadDtl] ADD  CONSTRAINT [DF_CargoUploadDtl_NofPcs]  DEFAULT ((0)) FOR [Row2]
GO
ALTER TABLE [dbo].[CargoUploadDtl] ADD  CONSTRAINT [DF_CargoUploadDtl_TotNetWgt]  DEFAULT ((0)) FOR [Row3]
GO
ALTER TABLE [dbo].[CargoUploadDtl] ADD  CONSTRAINT [DF_CargoUploadDtl_Row4]  DEFAULT ((0)) FOR [Row4]
GO
ALTER TABLE [dbo].[CargoUploadDtl] ADD  CONSTRAINT [DF_CargoUploadDtl_Row5]  DEFAULT ((0)) FOR [Row5]
GO
ALTER TABLE [dbo].[CargoUploadDtl] ADD  CONSTRAINT [DF_CargoUploadDtl_Row6]  DEFAULT ((0)) FOR [Row6]
GO
ALTER TABLE [dbo].[CargoUploadDtl] ADD  CONSTRAINT [DF_CargoUploadDtl_Row7]  DEFAULT ((0)) FOR [Row7]
GO
ALTER TABLE [dbo].[CargoUploadDtl] ADD  CONSTRAINT [DF_CargoUploadDtl_Row8]  DEFAULT ((0)) FOR [Row8]
GO
ALTER TABLE [dbo].[CargoUploadDtl] ADD  CONSTRAINT [DF_CargoUploadDtl_Row9]  DEFAULT ((0)) FOR [Row9]
GO
ALTER TABLE [dbo].[CargoUploadDtl] ADD  CONSTRAINT [DF_CargoUploadDtl_Row10]  DEFAULT ((0)) FOR [Row10]
GO
ALTER TABLE [dbo].[CargoUploadLorryNo] ADD  CONSTRAINT [DF_CargoUploadLorryNo_UpdNo]  DEFAULT ('') FOR [UpdNo]
GO
ALTER TABLE [dbo].[CargoUploadLorryNo] ADD  CONSTRAINT [DF_CargoUploadLorryNo_OrderNo]  DEFAULT ((0)) FOR [OrderNo]
GO
ALTER TABLE [dbo].[CargoUploadLorryNo] ADD  CONSTRAINT [DF_CargoUploadLorryNo_LorryNo]  DEFAULT ('') FOR [LorryNo]
GO
ALTER TABLE [dbo].[CargoUploadLorryNo] ADD  CONSTRAINT [DF_CargoUploadLorryNo_LoadQty]  DEFAULT ((0)) FOR [LoadQty]
GO
ALTER TABLE [dbo].[CargoUploadRcvNo] ADD  CONSTRAINT [DF_CargoUploadRcvNo_UpdNo]  DEFAULT ('') FOR [UpdNo]
GO
ALTER TABLE [dbo].[CargoUploadRcvNo] ADD  CONSTRAINT [DF_CargoUploadRcvNo_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[CargoUploadRcvNo] ADD  CONSTRAINT [DF_CargoUploadRcvNo_OrderNo]  DEFAULT ((0)) FOR [OrderNo]
GO
ALTER TABLE [dbo].[CargoUploadRcvNo] ADD  CONSTRAINT [DF_CargoUploadRcvNo_LoadQty]  DEFAULT ((0)) FOR [LoadQty]
GO
ALTER TABLE [dbo].[CaroItemOptionRFID] ADD  CONSTRAINT [DF_CaroItemOptionRFID_ContractNo]  DEFAULT ('') FOR [ContractNo]
GO
ALTER TABLE [dbo].[CaroItemOptionRFID] ADD  CONSTRAINT [DF_CaroItemOptionRFID_DeliveryNo]  DEFAULT ((0)) FOR [DeliveryNo]
GO
ALTER TABLE [dbo].[CaroItemOptionRFID] ADD  CONSTRAINT [DF_CaroItemOptionRFID_OptionSize]  DEFAULT ('') FOR [OptionSize]
GO
ALTER TABLE [dbo].[CaroItemOptionRFID] ADD  CONSTRAINT [DF_CaroItemOptionRFID_Ctns]  DEFAULT ((0)) FOR [Ctns]
GO
ALTER TABLE [dbo].[CaroItemOptionRFID] ADD  CONSTRAINT [DF_CaroItemOptionRFID_PCS]  DEFAULT ((0)) FOR [PCS]
GO
ALTER TABLE [dbo].[CartonTypes] ADD  CONSTRAINT [DF_CartonTypes_CartonType]  DEFAULT ('') FOR [CartonType]
GO
ALTER TABLE [dbo].[CartonTypes] ADD  CONSTRAINT [DF_CartonTypes_CtnLength]  DEFAULT ((0)) FOR [CtnLength]
GO
ALTER TABLE [dbo].[CartonTypes] ADD  CONSTRAINT [DF_CartonTypes_CtnWidth]  DEFAULT ((0)) FOR [CtnWidth]
GO
ALTER TABLE [dbo].[CartonTypes] ADD  CONSTRAINT [DF_CartonTypes_CtnHeight]  DEFAULT ((0)) FOR [CtnHeight]
GO
ALTER TABLE [dbo].[CartonTypes] ADD  CONSTRAINT [DF_CartonTypes_CtnWeight]  DEFAULT ((0)) FOR [CtnWeight]
GO
ALTER TABLE [dbo].[CloudMenu] ADD  CONSTRAINT [DF_CloudMenu_MenuID]  DEFAULT ('0') FOR [MenuID]
GO
ALTER TABLE [dbo].[CloudMenu] ADD  CONSTRAINT [DF_CloudMenu_MenuName]  DEFAULT ('') FOR [MenuName]
GO
ALTER TABLE [dbo].[CloudMenu] ADD  CONSTRAINT [DF_CloudMenu_MenuController]  DEFAULT ('') FOR [MenuController]
GO
ALTER TABLE [dbo].[CloudMenu] ADD  CONSTRAINT [DF_CloudMenu_MenuAction]  DEFAULT ('') FOR [MenuAction]
GO
ALTER TABLE [dbo].[CloudMenu] ADD  CONSTRAINT [DF_CloudMenu_MenuArea]  DEFAULT ('') FOR [MenuArea]
GO
ALTER TABLE [dbo].[CloudMenu] ADD  CONSTRAINT [DF_CloudMenu_MenuImageClass]  DEFAULT ('') FOR [MenuImageClass]
GO
ALTER TABLE [dbo].[CloudMenu] ADD  CONSTRAINT [DF_CloudMenu_MenuActiveli]  DEFAULT ('') FOR [MenuActiveli]
GO
ALTER TABLE [dbo].[CloudMenu] ADD  CONSTRAINT [DF_CloudMenu_MenuStatus]  DEFAULT ((0)) FOR [MenuStatus]
GO
ALTER TABLE [dbo].[CloudMenu] ADD  CONSTRAINT [DF_CloudMenu_MenuIsParent]  DEFAULT ((0)) FOR [MenuIsParent]
GO
ALTER TABLE [dbo].[CloudMenu] ADD  CONSTRAINT [DF_CloudMenu_MenuParentID]  DEFAULT ('0') FOR [MenuParentID]
GO
ALTER TABLE [dbo].[CloudMenu] ADD  CONSTRAINT [DF_CloudMenu_MenuIsChild1Parent]  DEFAULT ((0)) FOR [MenuIsChild1Parent]
GO
ALTER TABLE [dbo].[CloudMenu] ADD  CONSTRAINT [DF_CloudMenu_MenuChild1ParentID]  DEFAULT ('0') FOR [MenuChild1ParentID]
GO
ALTER TABLE [dbo].[CloudMenu] ADD  CONSTRAINT [DF_CloudMenu_MenuIsChild2Parent]  DEFAULT ((0)) FOR [MenuIsChild2Parent]
GO
ALTER TABLE [dbo].[CloudMenu] ADD  CONSTRAINT [DF_CloudMenu_MenuChild2ParentID]  DEFAULT ('0') FOR [MenuChild2ParentID]
GO
ALTER TABLE [dbo].[CloudMenu] ADD  CONSTRAINT [DF_CloudMenu_MenuActionPara]  DEFAULT ('') FOR [MenuActionPara]
GO
ALTER TABLE [dbo].[CloudMenuAllocation] ADD  CONSTRAINT [DF_CloudMenuAllocation_UserId]  DEFAULT ('') FOR [UserId]
GO
ALTER TABLE [dbo].[CloudMenuAllocation] ADD  CONSTRAINT [DF_CloudMenuAllocation_MenuID]  DEFAULT ('0') FOR [MenuID]
GO
ALTER TABLE [dbo].[CompanySetup] ADD  CONSTRAINT [DF_CompanySetup_DataSaveMethod]  DEFAULT ('Batch') FOR [DataSaveMethod]
GO
ALTER TABLE [dbo].[CompanySetup] ADD  CONSTRAINT [DF_CompanySetup_EmailFrom]  DEFAULT ('') FOR [EmailFrom]
GO
ALTER TABLE [dbo].[CompanySetup] ADD  CONSTRAINT [DF_CompanySetup_EmailFromPW]  DEFAULT ('') FOR [EmailFromPW]
GO
ALTER TABLE [dbo].[CompanySetup] ADD  CONSTRAINT [DF_CompanySetup_EmailSMTPPort]  DEFAULT ((0)) FOR [EmailSMTPPort]
GO
ALTER TABLE [dbo].[CompanySetup] ADD  CONSTRAINT [DF_CompanySetup_EmailSMTPServer]  DEFAULT ('') FOR [EmailSMTPServer]
GO
ALTER TABLE [dbo].[CompanySetup] ADD  CONSTRAINT [DF_CompanySetup_ShortName]  DEFAULT ('') FOR [ShortName]
GO
ALTER TABLE [dbo].[CompanySetup] ADD  CONSTRAINT [DF_CompanySetup_AllowDuplicateContract]  DEFAULT ('') FOR [CheckDuplicate]
GO
ALTER TABLE [dbo].[CompanySetup] ADD  CONSTRAINT [DF_CompanySetup_Delivery]  DEFAULT ('NonZero') FOR [Delivery]
GO
ALTER TABLE [dbo].[CompanySetup] ADD  CONSTRAINT [DF_CompanySetup_DeliveryAutoAdd]  DEFAULT ((0)) FOR [DeliveryAutoAdd]
GO
ALTER TABLE [dbo].[CompanySetup] ADD  CONSTRAINT [DF_CompanySetup_CountryCode]  DEFAULT ('') FOR [CountryCode]
GO
ALTER TABLE [dbo].[CompanySetup] ADD  CONSTRAINT [DF_CompanySetup_HubName]  DEFAULT ('') FOR [HubName]
GO
ALTER TABLE [dbo].[CompanySetup] ADD  CONSTRAINT [DF_CompanySetup_DuplicateBarcodeForSameGRN]  DEFAULT ((0)) FOR [DuplicateBarcodeForSameGRN]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_VesselOrderNo]  DEFAULT ((0)) FOR [VesselOrderNo]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_ContainerOrderNo]  DEFAULT ((0)) FOR [ContainerOrderNo]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_ContainerNo]  DEFAULT ((0)) FOR [ContainerNo]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_ContainerType]  DEFAULT ('') FOR [ContainerType]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_SealNo]  DEFAULT ('') FOR [SealNo]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_NextContainerNo]  DEFAULT ('') FOR [NextContainerNo]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_CntrOut]  DEFAULT ((0)) FOR [CntrOut]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_CntrOutBy]  DEFAULT ('') FOR [CntrOutBy]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_PCSBox]  DEFAULT ((0)) FOR [PCSBox]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_CtnsBox]  DEFAULT ((0)) FOR [CtnsBox]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_GrossWgtBox]  DEFAULT ((0)) FOR [GrossWgtBox]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_CBMBox]  DEFAULT ((0)) FOR [CBMBox]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_PCSGoh]  DEFAULT ((0)) FOR [PCSGoh]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_VCPGoh]  DEFAULT ((0)) FOR [VCPGoh]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_GrossWgtGoh]  DEFAULT ((0)) FOR [GrossWgtGoh]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_CBMGoh]  DEFAULT ((0)) FOR [CBMGoh]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_BarType]  DEFAULT ('') FOR [BarType]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_NofBars]  DEFAULT ((0)) FOR [NofBars]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_CreateBy]  DEFAULT ('') FOR [CreateBy]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_UpdateBy]  DEFAULT ('') FOR [UpdateBy]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_SealBy]  DEFAULT ('') FOR [SealBy]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_CntrNoBy]  DEFAULT ('') FOR [CntrNoBy]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_VGM]  DEFAULT ((0)) FOR [VGM]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_SCMLabelNo]  DEFAULT ('') FOR [SCMLabelNo]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_InvoiceStatus]  DEFAULT ('') FOR [InvoiceStatus]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_InvoiceNo]  DEFAULT ('') FOR [InvoiceNo]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_InvoiceConfirmStatus]  DEFAULT ('') FOR [InvoiceConfirmStatus]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_InvoiceConfirmBy]  DEFAULT ('') FOR [InvoiceConfirmBy]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_IsTallyUpload]  DEFAULT ((0)) FOR [IsTallyUpload]
GO
ALTER TABLE [dbo].[ContainerData] ADD  CONSTRAINT [DF_ContainerData_LastPalletNo]  DEFAULT ((0)) FOR [LastPalletNo]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_VesselOrderNo]  DEFAULT ((0)) FOR [VesselOrderNo]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_ContainerOrderNo]  DEFAULT ((0)) FOR [ContainerOrderNo]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_ContainerNo]  DEFAULT ('') FOR [ContainerNo]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_ContainerType]  DEFAULT ('') FOR [ContainerType]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_SealNo]  DEFAULT ('') FOR [SealNo]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_NextContainerNo]  DEFAULT ('') FOR [NextContainerNo]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_CntrOut]  DEFAULT ((0)) FOR [CntrOut]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_CntrOutBy]  DEFAULT ('') FOR [CntrOutBy]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_PCSBox]  DEFAULT ((0)) FOR [PCSBox]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_CtnsBox]  DEFAULT ((0)) FOR [CtnsBox]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_GrossWgtBox]  DEFAULT ((0)) FOR [GrossWgtBox]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_CBMBox]  DEFAULT ((0)) FOR [CBMBox]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_PCSGoh]  DEFAULT ((0)) FOR [PCSGoh]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_VCPGoh]  DEFAULT ((0)) FOR [VCPGoh]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_GrossWgtGoh]  DEFAULT ((0)) FOR [GrossWgtGoh]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_CBMGoh]  DEFAULT ((0)) FOR [CBMGoh]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_BarType]  DEFAULT ((0)) FOR [BarType]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_NofBars]  DEFAULT ((0)) FOR [NofBars]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_CreateBy]  DEFAULT ('') FOR [CreateBy]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_UpdateBy]  DEFAULT ('') FOR [UpdateBy]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_SealBy]  DEFAULT ('') FOR [SealBy]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_CntrNoBy]  DEFAULT ('') FOR [CntrNoBy]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_DOReleaseStatus]  DEFAULT ('') FOR [DOReleaseStatus]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_DOReleaseStatusBy]  DEFAULT ('') FOR [DOReleaseStatusBy]
GO
ALTER TABLE [dbo].[ContainerDataImport] ADD  CONSTRAINT [DF_ContainerDataImport_HBNo]  DEFAULT ('') FOR [HBNo]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_ContainerType]  DEFAULT ('') FOR [ContainerType]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_ContainerName]  DEFAULT ('') FOR [ContainerName]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_CreateBy]  DEFAULT ('') FOR [CreateBy]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_UpdateBy]  DEFAULT ('') FOR [UpdateBy]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_EdiType]  DEFAULT ('') FOR [EdiType]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_ASYCUDARef]  DEFAULT ('') FOR [ASYCUDARef]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_MaxCBM]  DEFAULT ((0)) FOR [MaxCBM]
GO
ALTER TABLE [dbo].[ContractForcast] ADD  CONSTRAINT [DF_ContractForcast_ContractNo]  DEFAULT ('') FOR [ContractNo]
GO
ALTER TABLE [dbo].[ContractForcast] ADD  CONSTRAINT [DF_ContractForcast_Mode]  DEFAULT ('') FOR [Mode]
GO
ALTER TABLE [dbo].[ContractForcast] ADD  CONSTRAINT [DF_ContractForcast_DeliveryNo]  DEFAULT ((0)) FOR [DeliveryNo]
GO
ALTER TABLE [dbo].[ContractForcast] ADD  CONSTRAINT [DF_ContractForcast_Units]  DEFAULT ((0)) FOR [Units]
GO
ALTER TABLE [dbo].[ContractForcast] ADD  CONSTRAINT [DF_ContractForcast_Departure]  DEFAULT ('') FOR [Departure]
GO
ALTER TABLE [dbo].[ContractForcast] ADD  CONSTRAINT [DF_ContractForcast_TradeLane]  DEFAULT ('') FOR [TradeLane]
GO
ALTER TABLE [dbo].[ContractForcast] ADD  CONSTRAINT [DF_ContractForcast_CargoType]  DEFAULT ('') FOR [CargoType]
GO
ALTER TABLE [dbo].[ContractForcast] ADD  CONSTRAINT [DF_ContractForcast_Warehouse]  DEFAULT ('') FOR [Warehouse]
GO
ALTER TABLE [dbo].[ContractForcast] ADD  CONSTRAINT [DF_ContractForcast_ItemNo]  DEFAULT ('') FOR [ItemNo]
GO
ALTER TABLE [dbo].[ContractForcast] ADD  CONSTRAINT [DF_ContractForcast_EnterBy]  DEFAULT ('') FOR [EnterBy]
GO
ALTER TABLE [dbo].[ContractForcast] ADD  CONSTRAINT [DF_ContractForcast_UpdateBy]  DEFAULT ('') FOR [UpdateBy]
GO
ALTER TABLE [dbo].[ContractForcast] ADD  CONSTRAINT [DF_ContractForcast_ShipperCode]  DEFAULT ('') FOR [ShipperCode]
GO
ALTER TABLE [dbo].[ContractForcast] ADD  CONSTRAINT [DF_ContractForcast_LocalOfficeStatus]  DEFAULT ('') FOR [LocalOfficeStatus]
GO
ALTER TABLE [dbo].[ContractForcast] ADD  CONSTRAINT [DF_ContractForcast_LocalOfficeStatusBy]  DEFAULT ('') FOR [LocalOfficeStatusBy]
GO
ALTER TABLE [dbo].[ContractForcast] ADD  CONSTRAINT [DF_ContractForcast_IntakeStatus]  DEFAULT ('') FOR [IntakeStatus]
GO
ALTER TABLE [dbo].[ContractListJMB] ADD  CONSTRAINT [DF_ContractListJMB_ContractNo]  DEFAULT ('') FOR [ContractNo]
GO
ALTER TABLE [dbo].[ContractsChainCodes] ADD  CONSTRAINT [DF_ContractsChainCodes_ChainCode]  DEFAULT ('') FOR [ChainCode]
GO
ALTER TABLE [dbo].[ContractsChainCodes] ADD  CONSTRAINT [DF_ContractsChainCodes_ChainName]  DEFAULT ('') FOR [ChainName]
GO
ALTER TABLE [dbo].[ContractsChainCodes] ADD  CONSTRAINT [DF_ContractsChainCodes_TPPartnerName]  DEFAULT ('') FOR [TPPartnerName]
GO
ALTER TABLE [dbo].[ContractsChainCodes] ADD  CONSTRAINT [DF_ContractsChainCodes_Range]  DEFAULT ('') FOR [Range]
GO
ALTER TABLE [dbo].[ContractsChainCodes] ADD  CONSTRAINT [DF_ContractsChainCodes_RangeBoxEAN]  DEFAULT ('') FOR [RangeBoxEAN]
GO
ALTER TABLE [dbo].[ContractsChainCodesCategory] ADD  CONSTRAINT [DF_ContractsChainCodesCategory_Category]  DEFAULT ('') FOR [Category]
GO
ALTER TABLE [dbo].[Country] ADD  CONSTRAINT [DF_Country_ContryCode]  DEFAULT ('') FOR [CountryCode]
GO
ALTER TABLE [dbo].[Country] ADD  CONSTRAINT [DF_Country_CountryName]  DEFAULT ('') FOR [CountryName]
GO
ALTER TABLE [dbo].[Country] ADD  CONSTRAINT [DF_Country_CargoMovement]  DEFAULT ('') FOR [CargoMovement]
GO
ALTER TABLE [dbo].[Country] ADD  CONSTRAINT [DF_Country_EnterBy]  DEFAULT ('') FOR [EnterBy]
GO
ALTER TABLE [dbo].[Country] ADD  CONSTRAINT [DF_Country_UpdateBy]  DEFAULT ('') FOR [UpdateBy]
GO
ALTER TABLE [dbo].[Country] ADD  CONSTRAINT [DF_Country_ContractBlock]  DEFAULT ((0)) FOR [ContractBlock]
GO
ALTER TABLE [dbo].[Currency] ADD  CONSTRAINT [DF_Currency_CurrencyRateMAWB]  DEFAULT ((0)) FOR [CurrencyRateMAWB]
GO
ALTER TABLE [dbo].[Currency] ADD  CONSTRAINT [DF_Currency_CreateBy]  DEFAULT ('') FOR [CreateBy]
GO
ALTER TABLE [dbo].[Currency] ADD  CONSTRAINT [DF_Currency_UpdateBy]  DEFAULT ('') FOR [UpdateBy]
GO
ALTER TABLE [dbo].[Currency] ADD  CONSTRAINT [DF_Currency_ASYCUDARef]  DEFAULT ('') FOR [ASYCUDARef]
GO
ALTER TABLE [dbo].[DepartmentCodeColors] ADD  CONSTRAINT [DF_DepartmentCodeColors_DepartmentCode]  DEFAULT ('') FOR [DepartmentCode]
GO
ALTER TABLE [dbo].[DepartmentCodeColors] ADD  CONSTRAINT [DF_DepartmentCodeColors_ColorDesciption]  DEFAULT ('') FOR [ColorDesciption]
GO
ALTER TABLE [dbo].[DepartmentCodeColors] ADD  CONSTRAINT [DF_DepartmentCodeColors_ColorCode]  DEFAULT ('') FOR [ColorCode]
GO
ALTER TABLE [dbo].[DestStore] ADD  CONSTRAINT [DF_Table_1_WhDes]  DEFAULT ('') FOR [WhDesMain]
GO
ALTER TABLE [dbo].[DestStore] ADD  CONSTRAINT [DF_DestStore_StoreCode]  DEFAULT ('') FOR [StoreCode]
GO
ALTER TABLE [dbo].[DestStore] ADD  CONSTRAINT [DF_DestStore_StoreName]  DEFAULT ('') FOR [StoreName]
GO
ALTER TABLE [dbo].[DestStore] ADD  CONSTRAINT [DF_DestStore_StoreLocation]  DEFAULT ('') FOR [StoreLcName]
GO
ALTER TABLE [dbo].[DestStore] ADD  CONSTRAINT [DF_DestStore_StoreLcPostalCode]  DEFAULT ('') FOR [StoreLcPostalCode]
GO
ALTER TABLE [dbo].[DestStore] ADD  CONSTRAINT [DF_DestStore_LoadOrder]  DEFAULT ((0)) FOR [LoadOrder]
GO
ALTER TABLE [dbo].[DestStore] ADD  CONSTRAINT [DF_DestStore_StoreGS128Code]  DEFAULT ('') FOR [StoreGS128Code]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_WhCode]  DEFAULT ('') FOR [WhCode]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_WhDes]  DEFAULT ('') FOR [WhDes]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_WhDesMain]  DEFAULT ('') FOR [WhDesMain]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_WhCountryCode]  DEFAULT ('') FOR [CountryCode]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_LoadOrder]  DEFAULT ((100)) FOR [LoadingOrder]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_OuterLabel]  DEFAULT ((0)) FOR [OuterLabel]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_EANLabelScan]  DEFAULT ((1)) FOR [EANLabelScan]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_ReworkApply]  DEFAULT ((0)) FOR [ReworkApply]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_NewPriceTag]  DEFAULT ((0)) FOR [RFIDPriceTag]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_NewPriceTagValidate]  DEFAULT ('') FOR [RFIDPriceTagValidate]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_RemoveOriginalTag]  DEFAULT ((0)) FOR [RemoveOriginalTag]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_JokerTagsForSets]  DEFAULT ((0)) FOR [JokerTagsForSets]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_CareWarningLabel]  DEFAULT ((0)) FOR [CareWarningLabel]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_PreValidationRun]  DEFAULT ((0)) FOR [PreValidationRun]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_EANLabelOuter]  DEFAULT ((0)) FOR [EANLabelOuterBox]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_EANDesCol]  DEFAULT ('') FOR [EANDesCol]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_NofCtnsChangeAtExport]  DEFAULT ((0)) FOR [PackAdditionalBox]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_BoxPMCode]  DEFAULT ('') FOR [BoxPMCode]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_HangerUse]  DEFAULT ((0)) FOR [HangerUse]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_EANLabelPiece]  DEFAULT ((0)) FOR [EANLabelPiece]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_PostValidation]  DEFAULT ((0)) FOR [PostValidation]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_StockUpdate]  DEFAULT ((0)) FOR [StockUpdate]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_AuthorizedToPOPlan]  DEFAULT ((1)) FOR [AuthorizedToPOPlan]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_ItemOptionFixedLength]  DEFAULT ((1)) FOR [ItemOptionFixedLength]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_ItemOptionManual]  DEFAULT ((0)) FOR [ItemOptionManual]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_PriceSymble]  DEFAULT ('$') FOR [PriceSymble]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_PrintPriceTag]  DEFAULT ((0)) FOR [PrintPriceTag]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_BoxPackSeperate]  DEFAULT ((0)) FOR [BoxPackSeperate]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_StorePick]  DEFAULT ((0)) FOR [StorePick]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_IsRfidOrder]  DEFAULT ((0)) FOR [IsRfidOrder]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_BrandText]  DEFAULT ('') FOR [BrandText]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_BarcodeType]  DEFAULT ('') FOR [BarcodeType]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_ProductCategory]  DEFAULT ((0)) FOR [ProductCategory]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_VasCheck]  DEFAULT ((1)) FOR [VasCheck]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_EnaVerification]  DEFAULT ((0)) FOR [EnaVerification]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_EanLblType]  DEFAULT ('1') FOR [EanLblType]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_Address]  DEFAULT ('') FOR [Address]
GO
ALTER TABLE [dbo].[DestWarehouse] ADD  CONSTRAINT [DF_DestWarehouse_LpnLblType]  DEFAULT ('1') FOR [LpnLblType]
GO
ALTER TABLE [dbo].[DestWarehouseMain] ADD  CONSTRAINT [DF_DestWarehouseMain_WhDesMain]  DEFAULT ('') FOR [WhDesMain]
GO
ALTER TABLE [dbo].[DestWarehouseMain] ADD  CONSTRAINT [DF_DestWarehouseMain_AuthorizedToPOPlan]  DEFAULT ((1)) FOR [AuthorizedToPOPlan]
GO
ALTER TABLE [dbo].[DestWarehouseMain] ADD  CONSTRAINT [DF_DestWarehouseMain_isInILS]  DEFAULT ((1)) FOR [isInILS]
GO
ALTER TABLE [dbo].[DestWarehouseMain] ADD  CONSTRAINT [DF_DestWarehouseMain_RfidBuff]  DEFAULT ((0.00)) FOR [RfidBuff]
GO
ALTER TABLE [dbo].[EPCs] ADD  CONSTRAINT [DF_EPCs_ENA]  DEFAULT ('') FOR [ENA]
GO
ALTER TABLE [dbo].[EPCs] ADD  CONSTRAINT [DF_EPCs_EPC]  DEFAULT ('') FOR [EPC]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_BookingFormat]  DEFAULT ('') FOR [BookingFormat]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_OriginPortRow]  DEFAULT ((0)) FOR [OriginPortRow]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_OriginPortCol]  DEFAULT ((0)) FOR [OriginPortCol]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_VesselRow]  DEFAULT ((0)) FOR [VesselRow]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_VesselCol]  DEFAULT ((0)) FOR [VesselCol]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_Table_1_ETD]  DEFAULT ((0)) FOR [ETDRow]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_ETDCol]  DEFAULT ((0)) FOR [ETDCol]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_PackTypeRow]  DEFAULT ((0)) FOR [PackTypeRow]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_PackTypeCol]  DEFAULT ((0)) FOR [PackTypeCol]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_LoadRefRow]  DEFAULT ((0)) FOR [LoadRefRow]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_LoadRefCol]  DEFAULT ((0)) FOR [LoadRefCol]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_VoyageRow]  DEFAULT ((0)) FOR [VoyageRow]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_VoyageCol]  DEFAULT ((0)) FOR [VoyageCol]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_ContainerSize]  DEFAULT ((0)) FOR [ContainerSizeRow]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_ContainerSizeCol]  DEFAULT ((0)) FOR [ContainerSizeCol]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_RowStart]  DEFAULT ((0)) FOR [RowStart]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_ContractNo]  DEFAULT ((0)) FOR [ContractNo]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_SupplierName]  DEFAULT ((0)) FOR [SupplierName]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_PCS]  DEFAULT ((0)) FOR [PCS]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_Ctns]  DEFAULT ((0)) FOR [Ctns]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_CBM]  DEFAULT ((0)) FOR [CBM]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_GrsWgt]  DEFAULT ((0)) FOR [GrsWgt]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_ShipDate]  DEFAULT ((0)) FOR [ShipDate]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_DC]  DEFAULT ((0)) FOR [DC]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_ItemNo]  DEFAULT ((0)) FOR [ItemNo]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_SheetName]  DEFAULT ('') FOR [SheetName]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_DFLong]  DEFAULT ('') FOR [DFLong]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_DFShort]  DEFAULT ('') FOR [DFShort]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_Cusdec]  DEFAULT ((0)) FOR [CusdecNo]
GO
ALTER TABLE [dbo].[ExcelBookingFormat] ADD  CONSTRAINT [DF_ExcelBookingFormat_PONo]  DEFAULT ((0)) FOR [PONo]
GO
ALTER TABLE [dbo].[ExpMWB] ADD  CONSTRAINT [DF_ExpMWB_JobNo]  DEFAULT ('') FOR [JobNo]
GO
ALTER TABLE [dbo].[ExpMWB] ADD  CONSTRAINT [DF_ExpMWB_VesselRegistryNo]  DEFAULT ((0)) FOR [VesselRegistryNo]
GO
ALTER TABLE [dbo].[ExpMWB] ADD  CONSTRAINT [DF_ExpMWB_Vessel]  DEFAULT ('') FOR [Vessel]
GO
ALTER TABLE [dbo].[ExpMWB] ADD  CONSTRAINT [DF_ExpMWB_isCancel]  DEFAULT ((0)) FOR [isCancel]
GO
ALTER TABLE [dbo].[ExpMWB] ADD  CONSTRAINT [DF_ExpMWB_CancelBy]  DEFAULT ('') FOR [CancelBy]
GO
ALTER TABLE [dbo].[ExpMWB] ADD  CONSTRAINT [DF_ExpMWB_isConfirm]  DEFAULT ((0)) FOR [isConfirm]
GO
ALTER TABLE [dbo].[ExpMWB] ADD  CONSTRAINT [DF_ExpMWB_ConfirmBy]  DEFAULT ('') FOR [ConfirmBy]
GO
ALTER TABLE [dbo].[ExpMWB] ADD  CONSTRAINT [DF_ExpMWB_CreateBy]  DEFAULT ('') FOR [CreateBy]
GO
ALTER TABLE [dbo].[ExpMWB] ADD  CONSTRAINT [DF_ExpMWB_UpdateBy]  DEFAULT ('') FOR [UpdateBy]
GO
ALTER TABLE [dbo].[ExpMWB] ADD  CONSTRAINT [DF_ExpMWB_LastContainerOrderNo]  DEFAULT ((0)) FOR [LastContainerOrderNo]
GO
ALTER TABLE [dbo].[ExpMWBCntrLoadPlan] ADD  CONSTRAINT [DF_ExpMWBCntrLoadPlan_JobNo]  DEFAULT ('') FOR [JobNo]
GO
ALTER TABLE [dbo].[ExpMWBCntrLoadPlan] ADD  CONSTRAINT [DF_ExpMWBCntrLoadPlan_ContainerOrderNo]  DEFAULT ((0)) FOR [ContainerOrderNo]
GO
ALTER TABLE [dbo].[ExpMWBCntrLoadPlan] ADD  CONSTRAINT [DF_ExpMWBCntrLoadPlan_OrderNo]  DEFAULT ((0)) FOR [OrderNo]
GO
ALTER TABLE [dbo].[ExpMWBCntrLoadPlan] ADD  CONSTRAINT [DF_ExpMWBCntrLoadPlan_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[ExpMWBCntrLoadPlan] ADD  CONSTRAINT [DF_ExpMWBCntrLoadPlan_isActive]  DEFAULT ((1)) FOR [isActive]
GO
ALTER TABLE [dbo].[ExpMWBCntrLoadPlan] ADD  CONSTRAINT [DF_ExpMWBCntrLoadPlan_LoadActual]  DEFAULT ((0)) FOR [LoadActual]
GO
ALTER TABLE [dbo].[ExpMWBCntrLoadPlan] ADD  CONSTRAINT [DF_ExpMWBCntrLoadPlan_LoadPosition]  DEFAULT ((1)) FOR [LoadPosition]
GO
ALTER TABLE [dbo].[ExpMWBContainerData] ADD  CONSTRAINT [DF_ExpMWBContainerData_JobNo]  DEFAULT ('') FOR [JobNo]
GO
ALTER TABLE [dbo].[ExpMWBContainerData] ADD  CONSTRAINT [DF_ExpMWBContainerData_OrderNo]  DEFAULT ((0)) FOR [OrderNo]
GO
ALTER TABLE [dbo].[ExpMWBContainerData] ADD  CONSTRAINT [DF_ExpMWBContainerData_ContainerNo]  DEFAULT ((0)) FOR [ContainerNo]
GO
ALTER TABLE [dbo].[ExpMWBContainerData] ADD  CONSTRAINT [DF_ExpMWBContainerData_ContainerType]  DEFAULT ('') FOR [ContainerType]
GO
ALTER TABLE [dbo].[ExpMWBContainerData] ADD  CONSTRAINT [DF_ExpMWBContainerData_SealNo]  DEFAULT ('') FOR [SealNo]
GO
ALTER TABLE [dbo].[ExpMWBContainerData] ADD  CONSTRAINT [DF_ExpMWBContainerData_LastLoadOrderNo]  DEFAULT ((0)) FOR [LastLoadOrderNo]
GO
ALTER TABLE [dbo].[ExpMWBContainerData] ADD  CONSTRAINT [DF_ExpMWBContainerData_CurrentLoadOrderNo]  DEFAULT ((0)) FOR [CurrentLoadOrderNo]
GO
ALTER TABLE [dbo].[ExpMWBContainerData] ADD  CONSTRAINT [DF_ExpMWBContainerData_Positions]  DEFAULT ((0)) FOR [Positions]
GO
ALTER TABLE [dbo].[ExpMWBContainerData] ADD  CONSTRAINT [DF_ExpMWBContainerData_NextContainerNo]  DEFAULT ('') FOR [NextContainerNo]
GO
ALTER TABLE [dbo].[ExpVesselRegistry] ADD  CONSTRAINT [DF_ExpVesselRegistry_RegistryNo]  DEFAULT ((0)) FOR [RegistryNo]
GO
ALTER TABLE [dbo].[ExpVesselRegistry] ADD  CONSTRAINT [DF_ExpVesselRegistry_Vessel]  DEFAULT (N'''') FOR [Vessel]
GO
ALTER TABLE [dbo].[ExpVesselRegistry] ADD  CONSTRAINT [DF_ExpVesselRegistry_VoyageNo]  DEFAULT ('') FOR [VoyageNo]
GO
ALTER TABLE [dbo].[ExpVesselRegistry] ADD  CONSTRAINT [DF_ExpVesselRegistry_MotherVessel]  DEFAULT ('') FOR [MotherVessel]
GO
ALTER TABLE [dbo].[ExpVesselRegistry] ADD  CONSTRAINT [DF_ExpVesselRegistry_MotherVoyageNo]  DEFAULT ('') FOR [MotherVoyageNo]
GO
ALTER TABLE [dbo].[ExpVesselRegistry] ADD  CONSTRAINT [DF_ExpVesselRegistry_PortLoading]  DEFAULT ('') FOR [PortLoading]
GO
ALTER TABLE [dbo].[ExpVesselRegistry] ADD  CONSTRAINT [DF_ExpVesselRegistry_CreateBy]  DEFAULT ('') FOR [CreateBy]
GO
ALTER TABLE [dbo].[ExpVesselRegistry] ADD  CONSTRAINT [DF_ExpVesselRegistry_UpdateBy]  DEFAULT ('') FOR [UpdateBy]
GO
ALTER TABLE [dbo].[ExpVesselRegistry] ADD  CONSTRAINT [DF_ExpVesselRegistry_BirthPlace]  DEFAULT ('') FOR [BirthPlace]
GO
ALTER TABLE [dbo].[ExpVesselRegistry] ADD  CONSTRAINT [DF_ExpVesselRegistry_VesselOpCode]  DEFAULT ('') FOR [VesselOpCode]
GO
ALTER TABLE [dbo].[ExpVesselRegistry] ADD  CONSTRAINT [DF_ExpVesselRegistry_BookingNo]  DEFAULT ('') FOR [BookingNo]
GO
ALTER TABLE [dbo].[FactorySupervisor] ADD  CONSTRAINT [DF_FactorySupervisor_SupervisorId]  DEFAULT ('') FOR [SupervisorId]
GO
ALTER TABLE [dbo].[FactorySupervisor] ADD  CONSTRAINT [DF_FactorySupervisor_SupervisorName]  DEFAULT ('') FOR [SupervisorName]
GO
ALTER TABLE [dbo].[FactorySupervisor] ADD  CONSTRAINT [DF_FactorySupervisor_SupervisorPW]  DEFAULT ('') FOR [SupervisorPW]
GO
ALTER TABLE [dbo].[FactorySupervisor] ADD  CONSTRAINT [DF_FactorySupervisor_EnterBy]  DEFAULT ('') FOR [EnterBy]
GO
ALTER TABLE [dbo].[FieldsLength] ADD  CONSTRAINT [DF_FieldsLength_ContractNoUk]  DEFAULT ((0)) FOR [ContractNoUk]
GO
ALTER TABLE [dbo].[FieldsLength] ADD  CONSTRAINT [DF_FieldsLength_ContractNoFranchise]  DEFAULT ((0)) FOR [ContractNoFranchise]
GO
ALTER TABLE [dbo].[FieldsLength] ADD  CONSTRAINT [DF_Table_1_ContractNoChoice]  DEFAULT ((0)) FOR [ContractNoMockshop]
GO
ALTER TABLE [dbo].[FieldsLength] ADD  CONSTRAINT [DF_FieldsLength_ContractNoChoice]  DEFAULT ((0)) FOR [ContractNoChoice]
GO
ALTER TABLE [dbo].[FieldsLength] ADD  CONSTRAINT [DF_FieldsLength_ItemNoUk]  DEFAULT ((0)) FOR [ItemNoUk]
GO
ALTER TABLE [dbo].[FieldsLength] ADD  CONSTRAINT [DF_FieldsLength_ItemNoFranchise]  DEFAULT ((0)) FOR [ItemNoFranchise]
GO
ALTER TABLE [dbo].[FieldsLength] ADD  CONSTRAINT [DF_FieldsLength_ItemNoMockshop]  DEFAULT ((0)) FOR [ItemNoMockshop]
GO
ALTER TABLE [dbo].[FieldsLength] ADD  CONSTRAINT [DF_FieldsLength_ItemNoChoice]  DEFAULT ((0)) FOR [ItemNoChoice]
GO
ALTER TABLE [dbo].[FldCaptions] ADD  CONSTRAINT [DF_FldCaptions_SysCaption]  DEFAULT ('') FOR [SysCaption]
GO
ALTER TABLE [dbo].[FldCaptions] ADD  CONSTRAINT [DF_FldCaptions_ContractNoCaption]  DEFAULT ('') FOR [ContractNoCaption]
GO
ALTER TABLE [dbo].[FldCaptions] ADD  CONSTRAINT [DF_FldCaptions_ItemNoCaption]  DEFAULT ('') FOR [ItemNoCaption]
GO
ALTER TABLE [dbo].[FldCaptions] ADD  CONSTRAINT [DF_FldCaptions_PONoCaption]  DEFAULT ('') FOR [PONoCaption]
GO
ALTER TABLE [dbo].[FldCaptions] ADD  CONSTRAINT [DF_FldCaptions_DeliveryNoCaption]  DEFAULT ('') FOR [DeliveryNoCaption]
GO
ALTER TABLE [dbo].[FranchiseCountry] ADD  CONSTRAINT [DF_FranchiseCountry_CountryName]  DEFAULT ('') FOR [CountryName]
GO
ALTER TABLE [dbo].[FranchiseCountry] ADD  CONSTRAINT [DF_FranchiseCountry_Warehouse]  DEFAULT ('') FOR [Warehouse]
GO
ALTER TABLE [dbo].[FranchiseCountry] ADD  CONSTRAINT [DF_FranchiseCountry_LoadingOrder]  DEFAULT ((0)) FOR [LoadingOrder]
GO
ALTER TABLE [dbo].[FranchiseCountry] ADD  CONSTRAINT [DF_FranchiseCountry_isActive]  DEFAULT ((1)) FOR [isActive]
GO
ALTER TABLE [dbo].[FranchiseCountry] ADD  CONSTRAINT [DF_FranchiseCountry_PortCode]  DEFAULT ('') FOR [PortCode]
GO
ALTER TABLE [dbo].[FranchiseCountry] ADD  CONSTRAINT [DF_FranchiseCountry_TradeLane]  DEFAULT ('') FOR [TradeLane]
GO
ALTER TABLE [dbo].[Grn] ADD  CONSTRAINT [DF_Grn_GrnNo]  DEFAULT ('') FOR [GrnNo]
GO
ALTER TABLE [dbo].[Grn] ADD  CONSTRAINT [DF_Grn_RefNo]  DEFAULT ('') FOR [RefNo]
GO
ALTER TABLE [dbo].[Grn] ADD  CONSTRAINT [DF_Grn_CusdecNo]  DEFAULT ('') FOR [CusdecNo]
GO
ALTER TABLE [dbo].[Grn] ADD  CONSTRAINT [DF_Grn_LorryNo]  DEFAULT ('') FOR [LorryNo]
GO
ALTER TABLE [dbo].[Grn] ADD  CONSTRAINT [DF_Grn_DriverName]  DEFAULT ('') FOR [DriverName]
GO
ALTER TABLE [dbo].[Grn] ADD  CONSTRAINT [DF_Grn_DriverContactNo]  DEFAULT ('') FOR [DriverContactNo]
GO
ALTER TABLE [dbo].[Grn] ADD  CONSTRAINT [DF_Grn_Remarks]  DEFAULT ('') FOR [Remarks]
GO
ALTER TABLE [dbo].[HangerTemplate] ADD  CONSTRAINT [DF_HangerTemplate_ContractNo]  DEFAULT ('') FOR [ContractNo]
GO
ALTER TABLE [dbo].[HangerTemplate] ADD  CONSTRAINT [DF_HangerTemplate_ItemOption]  DEFAULT ('') FOR [ItemOption]
GO
ALTER TABLE [dbo].[HangerTemplate] ADD  CONSTRAINT [DF_HangerTemplate_PMCode]  DEFAULT ('') FOR [PMCode]
GO
ALTER TABLE [dbo].[HangerTemplate] ADD  CONSTRAINT [DF_HangerTemplate_QtyNeed]  DEFAULT ((0)) FOR [QtyNeed]
GO
ALTER TABLE [dbo].[HangerTypes] ADD  CONSTRAINT [DF_HangerTypes_HangerType]  DEFAULT ('') FOR [HangerType]
GO
ALTER TABLE [dbo].[HangerTypes] ADD  CONSTRAINT [DF_HangerTypes_HangerUseFor]  DEFAULT ('') FOR [HangerUseFor]
GO
ALTER TABLE [dbo].[HangerTypes] ADD  CONSTRAINT [DF_HangerTypes_HangerWgt]  DEFAULT ((0)) FOR [HangerWgt]
GO
ALTER TABLE [dbo].[HangerTypes] ADD  CONSTRAINT [DF_HangerTypes_ListOrder]  DEFAULT ((0)) FOR [ListOrder]
GO
ALTER TABLE [dbo].[HistoryCargoBarCode] ADD  CONSTRAINT [DF_HistoryCargoBarCode_Barcode]  DEFAULT ('') FOR [Barcode]
GO
ALTER TABLE [dbo].[HistoryCargoBarCode] ADD  CONSTRAINT [DF_HistoryCargoBarCode_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[HistoryCargoBarCode] ADD  CONSTRAINT [DF_HistoryCargoBarCode_Location]  DEFAULT ('') FOR [Location]
GO
ALTER TABLE [dbo].[HistoryCargoBarCode] ADD  CONSTRAINT [DF_HistoryCargoBarCode_Status]  DEFAULT ('') FOR [Status]
GO
ALTER TABLE [dbo].[HistoryCargoBarCode] ADD  CONSTRAINT [DF_HistoryCargoBarCode_QCYes]  DEFAULT ((0)) FOR [QCYes]
GO
ALTER TABLE [dbo].[HistoryCargoBarCode] ADD  CONSTRAINT [DF_HistoryCargoBarCode_VerificationYes]  DEFAULT ((0)) FOR [VerificationYes]
GO
ALTER TABLE [dbo].[HistoryCargoBarCode] ADD  CONSTRAINT [DF_HistoryCargoBarCode_RtnNo]  DEFAULT ('') FOR [RtnNo]
GO
ALTER TABLE [dbo].[HistoryCargoBarCode] ADD  CONSTRAINT [DF_HistoryCargoBarCode_UpNo]  DEFAULT ('') FOR [UpNo]
GO
ALTER TABLE [dbo].[HistoryCargoBarCode] ADD  CONSTRAINT [DF_HistoryCargoBarCode_BarCodePcs]  DEFAULT ((0)) FOR [BarCodePcs]
GO
ALTER TABLE [dbo].[HistoryCargoBarCode] ADD  CONSTRAINT [DF_HistoryCargoBarCode_BarCodeGrsWgt]  DEFAULT ((0)) FOR [BarCodeGrsWgt]
GO
ALTER TABLE [dbo].[HistoryCargoBarCode] ADD  CONSTRAINT [DF_HistoryCargoBarCode_BarCodeNetWgt]  DEFAULT ((0)) FOR [BarCodeNetWgt]
GO
ALTER TABLE [dbo].[HistoryCargoBarCode] ADD  CONSTRAINT [DF_HistoryCargoBarCode_UpLoadCntrNo]  DEFAULT ('') FOR [UpLoadCntrNo]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_EntryType]  DEFAULT ('') FOR [EntryType]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_ShipperCode]  DEFAULT ('') FOR [ShipperCode]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_ContractNo]  DEFAULT ('') FOR [ContractNo]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_ItemNo]  DEFAULT ('') FOR [ItemNo]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_InvoiceNo]  DEFAULT ('') FOR [InvoiceNo]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_PONo]  DEFAULT ('') FOR [PONo]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_DeliveryNo]  DEFAULT ((0)) FOR [DeliveryNo]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_ShippingMode]  DEFAULT ('') FOR [ShippingMode]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_CargoType]  DEFAULT ('') FOR [CargoType]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_Ctns]  DEFAULT ((0)) FOR [Ctns]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_PCS]  DEFAULT ((0)) FOR [PCS]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_ScanQty]  DEFAULT ((0)) FOR [ScanQty]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_CBM]  DEFAULT ((0)) FOR [CBM]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_GrossWgt]  DEFAULT ((0)) FOR [GrossWgt]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_LorryNo]  DEFAULT ((0)) FOR [LorryNo]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_IntakeComments]  DEFAULT ('') FOR [IntakeComments]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_WHLocation]  DEFAULT ('') FOR [WHLocation]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_TradeLane]  DEFAULT ('') FOR [TradeLane]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_QCType]  DEFAULT ('') FOR [QCType]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_EnterBy]  DEFAULT ('') FOR [EnterBy]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_QCStatus]  DEFAULT ('') FOR [QCStatus]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_QCDone]  DEFAULT ((0)) FOR [QCDone]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_QCResult]  DEFAULT ('') FOR [QCResult]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_QCDoneBy]  DEFAULT ('') FOR [QCDoneBy]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_QCRemarks]  DEFAULT ('') FOR [QCRemarks]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_LimaValidate]  DEFAULT ((0)) FOR [LimaValidate]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_Authorized]  DEFAULT ((0)) FOR [Authorized]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_DC]  DEFAULT ('') FOR [DC]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_AirCost]  DEFAULT ('') FOR [AirCost]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_NextToPay]  DEFAULT ((0)) FOR [NextToPay]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_Verification]  DEFAULT ((0)) FOR [Verification]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_VerificationBy]  DEFAULT ('') FOR [VerificationBy]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_RemoveStatus]  DEFAULT ('') FOR [RemoveStatus]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_RemoveStatusDoneBy]  DEFAULT ('') FOR [RemoveStatusDoneBy]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_RemoveDoneBy]  DEFAULT ('') FOR [RemoveDoneBy]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_RemoveType]  DEFAULT ('') FOR [RemoveType]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_RemovalComments]  DEFAULT ('') FOR [RemovalComments]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_InQty]  DEFAULT ((0)) FOR [InQty]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_RemoveQty]  DEFAULT ((0)) FOR [RemoveQty]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_QCStaffCode]  DEFAULT ('') FOR [QCStaffCode]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_LoadNo]  DEFAULT ('') FOR [LoadNo]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_VesselOrderNo]  DEFAULT ((0)) FOR [VesselOrderNo]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_ContainerOrderNo]  DEFAULT ((0)) FOR [ContainerOrderNo]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_LoadPosition]  DEFAULT ((0)) FOR [LoadPosition]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_LimaPosition]  DEFAULT ((0)) FOR [LimaPosition]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_LoadingRef]  DEFAULT ('') FOR [LoadingRef]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_ShippingModeIn]  DEFAULT ('') FOR [ShippingModeIn]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_PCSIn]  DEFAULT ((0)) FOR [PCSIn]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_CtnsIn]  DEFAULT ((0)) FOR [CtnsIn]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_CBMIn]  DEFAULT ((0)) FOR [CBMIn]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_DeliveryNoIn]  DEFAULT ((0)) FOR [DeliveryNoIn]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_TradeLaneIn]  DEFAULT ('') FOR [TradeLaneIn]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_CountryIn]  DEFAULT ('') FOR [CountryIn]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_RemovePartQty]  DEFAULT ((0)) FOR [RemovePartQty]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_RemovePartPCS]  DEFAULT ((0)) FOR [RemovePartPCS]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_RemovePartCBM]  DEFAULT ((0)) FOR [RemovePartCBM]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_RemoveQtyPartScan]  DEFAULT ((0)) FOR [RemoveQtyPartScan]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_RemovePartBy]  DEFAULT ('') FOR [RemovePartBy]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_RemovePartQtyRemark]  DEFAULT ('') FOR [RemovePartQtyRemark]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_UpdateBy]  DEFAULT ('') FOR [UpdateBy]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_SplitRcvNo]  DEFAULT ('') FOR [SplitRcvNo]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_LoadType]  DEFAULT ('') FOR [LoadType]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_LorryNoLoad]  DEFAULT ('') FOR [LorryNoLoad]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_OutBy]  DEFAULT ('') FOR [OutBy]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_OldShippingMode]  DEFAULT ('') FOR [OldShippingMode]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_OldAirCost]  DEFAULT ('') FOR [OldAirCost]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_ModeChangeBy]  DEFAULT ('') FOR [ModeChangeBy]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_ShippingModeQC]  DEFAULT ('') FOR [ShippingModeQC]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_DeliveryNoQC]  DEFAULT ((0)) FOR [DeliveryNoQC]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_TradeLaneQC]  DEFAULT ('') FOR [TradeLaneQC]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_CountryQC]  DEFAULT ('') FOR [CountryQC]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_QCCtns]  DEFAULT ((0)) FOR [QCCtns]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_QCPcs]  DEFAULT ((0)) FOR [QCPcs]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_QCPcsReject]  DEFAULT ((0)) FOR [QCPcsReject]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_Descrepancy]  DEFAULT ('') FOR [Descrepancy]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_DescrepancyBy]  DEFAULT ('') FOR [DescrepancyBy]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_QCQty]  DEFAULT ((0)) FOR [QCQty]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_VerifyQty]  DEFAULT ((0)) FOR [VerifyQty]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_InChecked]  DEFAULT ((0)) FOR [InChecked]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_InCheckedComment]  DEFAULT ('') FOR [InCheckedComment]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_InCheckedBy]  DEFAULT ('') FOR [InCheckedBy]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_UpLiftBy]  DEFAULT ('') FOR [UpLiftBy]
GO
ALTER TABLE [dbo].[HistoryCargoReceived] ADD  CONSTRAINT [DF_HistoryCargoReceived_CargoQuality]  DEFAULT ('') FOR [CargoQuality]
GO
ALTER TABLE [dbo].[Holidays] ADD  CONSTRAINT [DF_Holidays_Year]  DEFAULT ((0)) FOR [Year]
GO
ALTER TABLE [dbo].[Holidays] ADD  CONSTRAINT [DF_Table_1_Ramark]  DEFAULT ('') FOR [Remark]
GO
ALTER TABLE [dbo].[InboundContainerData] ADD  CONSTRAINT [DF_InboundContainerData_VesselOrderNo]  DEFAULT ((0)) FOR [VesselOrderNo]
GO
ALTER TABLE [dbo].[InboundContainerData] ADD  CONSTRAINT [DF_InboundContainerData_ContainerOrderNo]  DEFAULT ((0)) FOR [ContainerOrderNo]
GO
ALTER TABLE [dbo].[InboundContainerData] ADD  CONSTRAINT [DF_InboundContainerData_ContainerNo]  DEFAULT ('') FOR [ContainerNo]
GO
ALTER TABLE [dbo].[InboundContainerData] ADD  CONSTRAINT [DF_InboundContainerData_ContainerType]  DEFAULT ('') FOR [ContainerType]
GO
ALTER TABLE [dbo].[InboundContainerData] ADD  CONSTRAINT [DF_InboundContainerData_NextContainerNo]  DEFAULT ('') FOR [NextContainerNo]
GO
ALTER TABLE [dbo].[InBoundVesselRegistry] ADD  CONSTRAINT [DF_InBoundVesselRegistry_VesselOrderNo]  DEFAULT ((0)) FOR [VesselOrderNo]
GO
ALTER TABLE [dbo].[InBoundVesselRegistry] ADD  CONSTRAINT [DF_InBoundVesselRegistry_VesselName]  DEFAULT ('') FOR [VesselName]
GO
ALTER TABLE [dbo].[InBoundVesselRegistry] ADD  CONSTRAINT [DF_InBoundVesselRegistry_Carrier]  DEFAULT ('') FOR [Carrier]
GO
ALTER TABLE [dbo].[InBoundVesselRegistry] ADD  CONSTRAINT [DF_InBoundVesselRegistry_VoyageNo]  DEFAULT ('') FOR [VoyageNo]
GO
ALTER TABLE [dbo].[InBoundVesselRegistry] ADD  CONSTRAINT [DF_InBoundVesselRegistry_LastContainerOrderNo]  DEFAULT ((0)) FOR [LastContainerOrderNo]
GO
ALTER TABLE [dbo].[ItemOptionMap] ADD  CONSTRAINT [DF_ItemOptionMap_ItemOption]  DEFAULT ('') FOR [ItemOption]
GO
ALTER TABLE [dbo].[ItemOptionMap] ADD  CONSTRAINT [DF_ItemOptionMap_OthItemId]  DEFAULT ('') FOR [OthItemId]
GO
ALTER TABLE [dbo].[LastGRNNo] ADD  CONSTRAINT [DF_LastGRNNo_Lno]  DEFAULT ((0)) FOR [Lno]
GO
ALTER TABLE [dbo].[LastGRNNo] ADD  CONSTRAINT [DF_LastGRNNo_BookingYear]  DEFAULT ((0)) FOR [BookingYear]
GO
ALTER TABLE [dbo].[LastRcvNo] ADD  CONSTRAINT [DF_LastRcvNo_Lno]  DEFAULT ((0)) FOR [Lno]
GO
ALTER TABLE [dbo].[LastRcvNo] ADD  CONSTRAINT [DF_LastRcvNo_Active]  DEFAULT ((0)) FOR [Active]
GO
ALTER TABLE [dbo].[LastRcvNo] ADD  CONSTRAINT [DF_LastRcvNo_PreFix]  DEFAULT ('A') FOR [PreFix]
GO
ALTER TABLE [dbo].[LastRcvNo] ADD  CONSTRAINT [DF_LastRcvNo_BookingYear]  DEFAULT ((0)) FOR [BookingYear]
GO
ALTER TABLE [dbo].[LIMAExcelFormat] ADD  CONSTRAINT [DF_LIMAExcelFormat_ColName]  DEFAULT ('') FOR [ColName]
GO
ALTER TABLE [dbo].[LIMAExcelFormat] ADD  CONSTRAINT [DF_LIMAExcelFormat_ColCaption]  DEFAULT ('') FOR [ColCaption]
GO
ALTER TABLE [dbo].[LIMAExcelFormat] ADD  CONSTRAINT [DF_LIMAExcelFormat_ColLen]  DEFAULT ((0)) FOR [ColLen]
GO
ALTER TABLE [dbo].[LIMAExcelFormat] ADD  CONSTRAINT [DF_LIMAExcelFormat_ColDefVal]  DEFAULT ('') FOR [ColDefVal]
GO
ALTER TABLE [dbo].[LIMAExcelFormat] ADD  CONSTRAINT [DF_LIMAExcelFormat_OrderNo]  DEFAULT ((0)) FOR [OrderNo]
GO
ALTER TABLE [dbo].[Locations] ADD  CONSTRAINT [DF_Locations_LocationCode]  DEFAULT ('') FOR [LocationCode]
GO
ALTER TABLE [dbo].[OkToLoadReason] ADD  CONSTRAINT [DF_OkToLoadReason_Reason]  DEFAULT ('') FOR [Reason]
GO
ALTER TABLE [dbo].[OkToLoadReason] ADD  CONSTRAINT [DF_OkToLoadReason_ReasonOrder]  DEFAULT ((0)) FOR [ReasonOrder]
GO
ALTER TABLE [dbo].[OkToLoadReason] ADD  CONSTRAINT [DF_OkToLoadReason_DtlReson]  DEFAULT ('') FOR [DtlReson]
GO
ALTER TABLE [dbo].[OkToLoadReason] ADD  CONSTRAINT [DF_OkToLoadReason_Warehouse]  DEFAULT ('') FOR [Warehouse]
GO
ALTER TABLE [dbo].[OptionSizes] ADD  CONSTRAINT [DF_OptionSizes_OptionNo]  DEFAULT ('') FOR [OptionNo]
GO
ALTER TABLE [dbo].[OptionSizes] ADD  CONSTRAINT [DF_OptionSizes_OptionSize]  DEFAULT ('') FOR [OptionSize]
GO
ALTER TABLE [dbo].[OptionSizes] ADD  CONSTRAINT [DF_OptionSizes_OptionSizeDescription]  DEFAULT (N'''') FOR [OptionSizeDescription]
GO
ALTER TABLE [dbo].[PackJobNo] ADD  CONSTRAINT [DF_PackJobNo_JobYear]  DEFAULT ((0)) FOR [JobYear]
GO
ALTER TABLE [dbo].[PackJobNo] ADD  CONSTRAINT [DF_PackJobNo_LastJobNo]  DEFAULT ((0)) FOR [LastJobNo]
GO
ALTER TABLE [dbo].[PackPOCtnSummary] ADD  CONSTRAINT [DF_PackPOCtnSummary_JobNo]  DEFAULT ('') FOR [JobNo]
GO
ALTER TABLE [dbo].[PackPOCtnSummary] ADD  CONSTRAINT [DF_PackPOCtnSummary_OptionNo]  DEFAULT ('') FOR [OptionNo]
GO
ALTER TABLE [dbo].[PackPOCtnSummary] ADD  CONSTRAINT [DF_PackPOCtnSummary_CtnType]  DEFAULT ('') FOR [CtnType]
GO
ALTER TABLE [dbo].[PackPOCtnSummary] ADD  CONSTRAINT [DF_PackPOCtnSummary_CtnLength]  DEFAULT ((0)) FOR [CtnLength]
GO
ALTER TABLE [dbo].[PackPOCtnSummary] ADD  CONSTRAINT [DF_PackPOCtnSummary_CtnWidth]  DEFAULT ((0)) FOR [CtnWidth]
GO
ALTER TABLE [dbo].[PackPOCtnSummary] ADD  CONSTRAINT [DF_PackPOCtnSummary_CtnHeight]  DEFAULT ((0)) FOR [CtnHeight]
GO
ALTER TABLE [dbo].[PackPOCtnSummary] ADD  CONSTRAINT [DF_PackPOCtnSummary_NofCtn]  DEFAULT ((0)) FOR [NofCtn]
GO
ALTER TABLE [dbo].[PackPOCtnSummary] ADD  CONSTRAINT [DF_PackPOCtnSummary_CtnWgt]  DEFAULT ((0)) FOR [CtnWgt]
GO
ALTER TABLE [dbo].[PackPOCtnSummary] ADD  CONSTRAINT [DF_PackPOCtnSummary_GrsWgt]  DEFAULT ((0)) FOR [GrsWgt]
GO
ALTER TABLE [dbo].[PackPOCtnSummary] ADD  CONSTRAINT [DF_PackPOCtnSummary_CBM]  DEFAULT ((0)) FOR [CBM]
GO
ALTER TABLE [dbo].[PackPoPlan] ADD  CONSTRAINT [DF_PackPoPlan_JobNo]  DEFAULT ('') FOR [JobNo]
GO
ALTER TABLE [dbo].[PackPoPlan] ADD  CONSTRAINT [DF_PackPoPlan_ShipperCode]  DEFAULT ('') FOR [ShipperCode]
GO
ALTER TABLE [dbo].[PackPoPlan] ADD  CONSTRAINT [DF_PackPoPlan_ContractNo]  DEFAULT ('') FOR [ContractNo]
GO
ALTER TABLE [dbo].[PackPoPlan] ADD  CONSTRAINT [DF_PackPoPlan_DeliveryNo]  DEFAULT ((0)) FOR [DeliveryNo]
GO
ALTER TABLE [dbo].[PackPoPlan] ADD  CONSTRAINT [DF_PackPoPlan_ItemNo]  DEFAULT ('') FOR [ItemNo]
GO
ALTER TABLE [dbo].[PackPoPlan] ADD  CONSTRAINT [DF_PackPoPlan_Ctns]  DEFAULT ((0)) FOR [Ctns]
GO
ALTER TABLE [dbo].[PackPoPlan] ADD  CONSTRAINT [DF_PackPoPlan_CtnsPack]  DEFAULT ((0)) FOR [CtnsPack]
GO
ALTER TABLE [dbo].[PackPoPlan] ADD  CONSTRAINT [DF_PackPoPlan_PlanBy]  DEFAULT ('') FOR [PlanBy]
GO
ALTER TABLE [dbo].[PackPoPlan] ADD  CONSTRAINT [DF_PackPoPlan_LastCtnOrderNo]  DEFAULT ((0)) FOR [LastCtnOrderNo]
GO
ALTER TABLE [dbo].[PackPoPlan] ADD  CONSTRAINT [DF_PackPoPlan_CtnsComplete]  DEFAULT ((0)) FOR [CtnsComplete]
GO
ALTER TABLE [dbo].[PackPoPlan] ADD  CONSTRAINT [DF_PackPoPlan_WgtStatus]  DEFAULT ('') FOR [WgtStatus]
GO
ALTER TABLE [dbo].[PackPoPlan] ADD  CONSTRAINT [DF_PackPoPlan_WgtStatusBy]  DEFAULT ('') FOR [WgtStatusBy]
GO
ALTER TABLE [dbo].[PackPoPlan] ADD  CONSTRAINT [DF_PackPoPlan_LastWongNo]  DEFAULT ((0)) FOR [LastWrongNo]
GO
ALTER TABLE [dbo].[PackPoPlan] ADD  CONSTRAINT [DF_PackPoPlan_ScanCompStatus]  DEFAULT ('') FOR [ScanCompStatus]
GO
ALTER TABLE [dbo].[PackPoPlan] ADD  CONSTRAINT [DF_PackPoPlan_ScanCompBy]  DEFAULT ('') FOR [ScanCompBy]
GO
ALTER TABLE [dbo].[PackPoPlan] ADD  CONSTRAINT [DF_PackPoPlan_ProductGroup]  DEFAULT ('') FOR [ProductGroup]
GO
ALTER TABLE [dbo].[PackPoPlan] ADD  CONSTRAINT [DF_PackPoPlan_Supplier]  DEFAULT ('') FOR [Supplier]
GO
ALTER TABLE [dbo].[PackPoPlan] ADD  CONSTRAINT [DF_PackPoPlan_Contact]  DEFAULT ('') FOR [Contact]
GO
ALTER TABLE [dbo].[PackPoPlan] ADD  CONSTRAINT [DF_PackPoPlan_BookingRef]  DEFAULT ('') FOR [BookingRef]
GO
ALTER TABLE [dbo].[PackPoPlan] ADD  CONSTRAINT [DF_PackPoPlan_ItemDes]  DEFAULT ('') FOR [ItemDes]
GO
ALTER TABLE [dbo].[PackPoPlan] ADD  CONSTRAINT [DF_PackPoPlan_ShippingMode]  DEFAULT ('') FOR [ShippingMode]
GO
ALTER TABLE [dbo].[PackPoPlan] ADD  CONSTRAINT [DF_PackPoPlan_TypeRef]  DEFAULT ('') FOR [TypeRef]
GO
ALTER TABLE [dbo].[PackPOPlanCtn] ADD  CONSTRAINT [DF_PackPOPlanCtn_JobNo]  DEFAULT ('') FOR [JobNo]
GO
ALTER TABLE [dbo].[PackPOPlanCtn] ADD  CONSTRAINT [DF_PackPOPlanCtn_CtnOrderNo]  DEFAULT ((0)) FOR [CtnOrderNo]
GO
ALTER TABLE [dbo].[PackPOPlanCtn] ADD  CONSTRAINT [DF_PackPOPlanCtn_CtnBarCode]  DEFAULT ('') FOR [CtnBarCode]
GO
ALTER TABLE [dbo].[PackPOPlanCtn] ADD  CONSTRAINT [DF_PackPOPlanCtn_CtnType]  DEFAULT ('') FOR [CtnType]
GO
ALTER TABLE [dbo].[PackPOPlanCtn] ADD  CONSTRAINT [DF_PackPOPlanCtn_CtnLength]  DEFAULT ((0)) FOR [CtnLength]
GO
ALTER TABLE [dbo].[PackPOPlanCtn] ADD  CONSTRAINT [DF_PackPOPlanCtn_CtnWidth]  DEFAULT ((0)) FOR [CtnWidth]
GO
ALTER TABLE [dbo].[PackPOPlanCtn] ADD  CONSTRAINT [DF_PackPOPlanCtn_CtnHeight]  DEFAULT ((0)) FOR [CtnHeight]
GO
ALTER TABLE [dbo].[PackPOPlanCtn] ADD  CONSTRAINT [DF_PackPOPlanCtn_PackQty]  DEFAULT ((0)) FOR [PackQty]
GO
ALTER TABLE [dbo].[PackPOPlanCtn] ADD  CONSTRAINT [DF_PackPOPlanCtn_EnterBy]  DEFAULT ('') FOR [EnterBy]
GO
ALTER TABLE [dbo].[PackPOPlanCtn] ADD  CONSTRAINT [DF_PackPOPlanCtn_OptionSize]  DEFAULT ('') FOR [OptionSize]
GO
ALTER TABLE [dbo].[PackPOPlanCtn] ADD  CONSTRAINT [DF_PackPOPlanCtn_CtnID]  DEFAULT ('') FOR [CtnID]
GO
ALTER TABLE [dbo].[PackPOPlanCtn] ADD  CONSTRAINT [DF_PackPOPlanCtn_CompleteStatus]  DEFAULT ('') FOR [CompleteStatus]
GO
ALTER TABLE [dbo].[PackPOPlanCtn] ADD  CONSTRAINT [DF_PackPOPlanCtn_CompleteBy]  DEFAULT ('') FOR [CompleteBy]
GO
ALTER TABLE [dbo].[PackPOPlanCtn] ADD  CONSTRAINT [DF_PackPOPlanCtn_WrongQty]  DEFAULT ((0)) FOR [WrongQty]
GO
ALTER TABLE [dbo].[PackPOPlanCtn] ADD  CONSTRAINT [DF_PackPOPlanCtn_GrsWgt]  DEFAULT ((0)) FOR [GrsWgt]
GO
ALTER TABLE [dbo].[PackPOPlanCtn] ADD  CONSTRAINT [DF_PackPOPlanCtn_NetWgt]  DEFAULT ((0)) FOR [NetWgt]
GO
ALTER TABLE [dbo].[PackPOPlanCtnSize] ADD  CONSTRAINT [DF_PackPOPlanCtnSize_JobNo]  DEFAULT ('') FOR [JobNo]
GO
ALTER TABLE [dbo].[PackPOPlanCtnSize] ADD  CONSTRAINT [DF_PackPOPlanCtnSize_CtnOrderNo]  DEFAULT ((0)) FOR [CtnOrderNo]
GO
ALTER TABLE [dbo].[PackPOPlanCtnSize] ADD  CONSTRAINT [DF_PackPOPlanCtnSize_SizeBarcode]  DEFAULT ('') FOR [SizeBarcode]
GO
ALTER TABLE [dbo].[PackPOPlanCtnSizeWrong] ADD  CONSTRAINT [DF_PackPOPlanCtnSizeWrong_JobNo]  DEFAULT ('') FOR [JobNo]
GO
ALTER TABLE [dbo].[PackPOPlanCtnSizeWrong] ADD  CONSTRAINT [DF_PackPOPlanCtnSizeWrong_CtnOrderNo]  DEFAULT ((0)) FOR [CtnOrderNo]
GO
ALTER TABLE [dbo].[PackPOPlanCtnSizeWrong] ADD  CONSTRAINT [DF_PackPOPlanCtnSizeWrong_UnlockedBy]  DEFAULT ('') FOR [UnlockedBy]
GO
ALTER TABLE [dbo].[PackPOPlanCtnSizeWrong] ADD  CONSTRAINT [DF_PackPOPlanCtnSizeWrong_ErrorType]  DEFAULT ('') FOR [ErrorType]
GO
ALTER TABLE [dbo].[PackPOPlanCtnSizeWrong] ADD  CONSTRAINT [DF_PackPOPlanCtnSizeWrong_CtnBarCode]  DEFAULT ('') FOR [CtnBarCode]
GO
ALTER TABLE [dbo].[PackPOPlanCtnSizeWrong] ADD  CONSTRAINT [DF_PackPOPlanCtnSizeWrong_SizeCorrect]  DEFAULT ('') FOR [SizeCorrect]
GO
ALTER TABLE [dbo].[PackPOPlanCtnSizeWrong] ADD  CONSTRAINT [DF_PackPOPlanCtnSizeWrong_SizeWrong]  DEFAULT ('') FOR [ValWrong]
GO
ALTER TABLE [dbo].[PackPoPlanSize] ADD  CONSTRAINT [DF_PackPoPlanSize_JobNo]  DEFAULT ('') FOR [JobNo]
GO
ALTER TABLE [dbo].[PackPoPlanSize] ADD  CONSTRAINT [DF_PackPoPlanSize_OptionSize]  DEFAULT ('') FOR [OptionSize]
GO
ALTER TABLE [dbo].[PackPoPlanSize] ADD  CONSTRAINT [DF_PackPoPlanSize_OptionSizeDes]  DEFAULT ('') FOR [OptionSizeDes]
GO
ALTER TABLE [dbo].[PackPoPlanSize] ADD  CONSTRAINT [DF_PackPoPlanSize_PlanQty]  DEFAULT ((0)) FOR [PlanQty]
GO
ALTER TABLE [dbo].[PalletRacks] ADD  CONSTRAINT [DF_PalletRacks_RackNo]  DEFAULT ('') FOR [RackNo]
GO
ALTER TABLE [dbo].[PalletRacks] ADD  CONSTRAINT [DF_PalletRacks_NofRows]  DEFAULT ((0)) FOR [NofRows]
GO
ALTER TABLE [dbo].[PalletRacks] ADD  CONSTRAINT [DF_PalletRacks_NofLayers]  DEFAULT ((0)) FOR [NofLayers]
GO
ALTER TABLE [dbo].[PalletRacks] ADD  CONSTRAINT [DF_PalletRacks_NofPositions]  DEFAULT ((0)) FOR [NofPositions]
GO
ALTER TABLE [dbo].[PalletRacksUtilization] ADD  CONSTRAINT [DF_PalletRacksUtilization_PositionNo]  DEFAULT ('') FOR [PositionNo]
GO
ALTER TABLE [dbo].[PalletRacksUtilization] ADD  CONSTRAINT [DF_PalletRacksUtilization_GrnNo]  DEFAULT (N'''') FOR [GrnNo]
GO
ALTER TABLE [dbo].[PalletRacksUtilization] ADD  CONSTRAINT [DF_PalletRacksUtilization_PalletNo]  DEFAULT ('') FOR [PalletNo]
GO
ALTER TABLE [dbo].[PalletTypes] ADD  CONSTRAINT [DF_PalletTypes_PalletType]  DEFAULT ('') FOR [PalletType]
GO
ALTER TABLE [dbo].[PalletTypes] ADD  CONSTRAINT [DF_PalletTypes_UnitsHold]  DEFAULT ((0)) FOR [UnitsHold]
GO
ALTER TABLE [dbo].[PickENADataSheet] ADD  CONSTRAINT [DF_PickENADataSheet_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[PickENADataSheet] ADD  CONSTRAINT [DF_PickENADataSheet_ItemOption]  DEFAULT ('') FOR [ItemOption]
GO
ALTER TABLE [dbo].[PickENADataSheet] ADD  CONSTRAINT [DF_PickENADataSheet_ENA]  DEFAULT ('') FOR [ENA]
GO
ALTER TABLE [dbo].[PickENADataSheet] ADD  CONSTRAINT [DF_PickENADataSheet_Size]  DEFAULT ('') FOR [Size]
GO
ALTER TABLE [dbo].[PickENADataSheet] ADD  CONSTRAINT [DF_Table_1_Color]  DEFAULT ('') FOR [ItemColor]
GO
ALTER TABLE [dbo].[PickENADataSheet] ADD  CONSTRAINT [DF_PickENADataSheet_ItemDes]  DEFAULT ('') FOR [ItemDes]
GO
ALTER TABLE [dbo].[PickENADataSheet] ADD  CONSTRAINT [DF_PickENADataSheet_InCorrectENA]  DEFAULT ('') FOR [InCorrectENA]
GO
ALTER TABLE [dbo].[PickENADataSheet] ADD  CONSTRAINT [DF_PickENADataSheet_EAN123]  DEFAULT ('') FOR [EAN123]
GO
ALTER TABLE [dbo].[PickENADataSheet] ADD  CONSTRAINT [DF_PickENADataSheet_colorOld]  DEFAULT ('') FOR [colorOld]
GO
ALTER TABLE [dbo].[PickENADataSheet] ADD  CONSTRAINT [DF_PickENADataSheet_SizeOld]  DEFAULT ('') FOR [SizeOld]
GO
ALTER TABLE [dbo].[PickENADataSheet] ADD  CONSTRAINT [DF_PickENADataSheet_ItemDesUSA]  DEFAULT ('') FOR [ItemDesUSA]
GO
ALTER TABLE [dbo].[PickENADataSheet] ADD  CONSTRAINT [DF_PickENADataSheet_EnterSource]  DEFAULT ('EAN') FOR [EnterSource]
GO
ALTER TABLE [dbo].[PickENADataSheet] ADD  CONSTRAINT [DF_PickENADataSheet_UpdateSource]  DEFAULT ('EAN') FOR [UpdateSource]
GO
ALTER TABLE [dbo].[PickENADataSheet] ADD  CONSTRAINT [DF_PickENADataSheet_SizeUSA]  DEFAULT ('') FOR [SizeUSA]
GO
ALTER TABLE [dbo].[PickENADataSheet] ADD  CONSTRAINT [DF_PickENADataSheet_DepartmentCode]  DEFAULT ('') FOR [DepartmentCode]
GO
ALTER TABLE [dbo].[PickENADataSheetDC] ADD  CONSTRAINT [DF_PickENADataSheetDC_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[PickENADataSheetDC] ADD  CONSTRAINT [DF_PickENADataSheetDC_ItemOption]  DEFAULT ('') FOR [ItemOption]
GO
ALTER TABLE [dbo].[PickENADataSheetDC] ADD  CONSTRAINT [DF_PickENADataSheetDC_ENA]  DEFAULT ('') FOR [ENA]
GO
ALTER TABLE [dbo].[PickENADataSheetDC] ADD  CONSTRAINT [DF_PickENADataSheetDC_Size]  DEFAULT ('') FOR [Size]
GO
ALTER TABLE [dbo].[PickENADataSheetDC] ADD  CONSTRAINT [DF_PickENADataSheetDC_ItemColor]  DEFAULT ('') FOR [ItemColor]
GO
ALTER TABLE [dbo].[PickENADataSheetDC] ADD  CONSTRAINT [DF_PickENADataSheetDC_ItemDes]  DEFAULT ('') FOR [ItemDes]
GO
ALTER TABLE [dbo].[PickENADataSheetDC] ADD  CONSTRAINT [DF_PickENADataSheetDC_ItemDesUSA]  DEFAULT ('') FOR [ItemDesUSA]
GO
ALTER TABLE [dbo].[PickENADataSheetDC] ADD  CONSTRAINT [DF_PickENADataSheetDC_EnterSource]  DEFAULT ('') FOR [EnterSource]
GO
ALTER TABLE [dbo].[PickENADataSheetDC] ADD  CONSTRAINT [DF_PickENADataSheetDC_UpdateSource]  DEFAULT ('') FOR [UpdateSource]
GO
ALTER TABLE [dbo].[PickSwingTicketData] ADD  CONSTRAINT [DF_PickSwingTicketData_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[PickSwingTicketData] ADD  CONSTRAINT [DF_PickSwingTicketData_BarCode]  DEFAULT ('') FOR [BarCode]
GO
ALTER TABLE [dbo].[PickSwingTicketData] ADD  CONSTRAINT [DF_PickSwingTicketData_SwingTicketBarCode]  DEFAULT ('') FOR [SwingTicketBarCode]
GO
ALTER TABLE [dbo].[PickSwingTicketData] ADD  CONSTRAINT [DF_PickSwingTicketData_ErrorDes]  DEFAULT ('') FOR [ErrorDes]
GO
ALTER TABLE [dbo].[PickSwingTicketData] ADD  CONSTRAINT [DF_PickSwingTicketData_ReworkOk]  DEFAULT ((0)) FOR [ReworkOk]
GO
ALTER TABLE [dbo].[PickSwingTicketData] ADD  CONSTRAINT [DF_PickSwingTicketData_EPCNo]  DEFAULT ('') FOR [EPCNo]
GO
ALTER TABLE [dbo].[PicsExport] ADD  CONSTRAINT [DF_PicsExport_VesselOrderNo]  DEFAULT ((0)) FOR [VesselOrderNo]
GO
ALTER TABLE [dbo].[PicsExport] ADD  CONSTRAINT [DF_PicsExport_ContainerOrderNo]  DEFAULT ((0)) FOR [ContainerOrderNo]
GO
ALTER TABLE [dbo].[PicsExport] ADD  CONSTRAINT [DF_PicsExport_PicPath]  DEFAULT ('') FOR [PicPath]
GO
ALTER TABLE [dbo].[PicsExport] ADD  CONSTRAINT [DF_PicsExport_PicName]  DEFAULT ('') FOR [PicName]
GO
ALTER TABLE [dbo].[PicsExport] ADD  CONSTRAINT [DF_PicsExport_Remarks]  DEFAULT ('') FOR [Remarks]
GO
ALTER TABLE [dbo].[PicsImport] ADD  CONSTRAINT [DF_PicsImport_VesselOrderNo]  DEFAULT ((0)) FOR [VesselOrderNo]
GO
ALTER TABLE [dbo].[PicsImport] ADD  CONSTRAINT [DF_PicsImport_ContainerOrderNo]  DEFAULT ((0)) FOR [ContainerOrderNo]
GO
ALTER TABLE [dbo].[PicsImport] ADD  CONSTRAINT [DF_PicsImport_PicName]  DEFAULT ('') FOR [PicName]
GO
ALTER TABLE [dbo].[PicsImport] ADD  CONSTRAINT [DF_PicsImport_Remarks]  DEFAULT ('') FOR [Remarks]
GO
ALTER TABLE [dbo].[PicsRework] ADD  CONSTRAINT [DF_PicsRework_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[PicsRework] ADD  CONSTRAINT [DF_PicsRework_PicPath]  DEFAULT ('') FOR [PicPath]
GO
ALTER TABLE [dbo].[PicsRework] ADD  CONSTRAINT [DF_PicsRework_PicName]  DEFAULT ('') FOR [PicName]
GO
ALTER TABLE [dbo].[PicsRework] ADD  CONSTRAINT [DF_PicsRework_Remarks]  DEFAULT ('') FOR [Remarks]
GO
ALTER TABLE [dbo].[PicsTmp] ADD  CONSTRAINT [DF_PicsTmp_UserId]  DEFAULT ('') FOR [UserId]
GO
ALTER TABLE [dbo].[PicsTmp] ADD  CONSTRAINT [DF_PicsTmp_PicPath]  DEFAULT ('') FOR [PicPath]
GO
ALTER TABLE [dbo].[PicsTmp] ADD  CONSTRAINT [DF_PicsTmp_PicName]  DEFAULT ('') FOR [PicName]
GO
ALTER TABLE [dbo].[PicsUnload] ADD  CONSTRAINT [DF_PicsUnload_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[PicsUnload] ADD  CONSTRAINT [DF_PicsUnload_PicPath]  DEFAULT ('') FOR [PicPath]
GO
ALTER TABLE [dbo].[PicsUnload] ADD  CONSTRAINT [DF_PicsUnload_PicName]  DEFAULT ('') FOR [PicName]
GO
ALTER TABLE [dbo].[PicsUnload] ADD  CONSTRAINT [DF_PicsUnload_Remarks]  DEFAULT ('') FOR [Remarks]
GO
ALTER TABLE [dbo].[PMBoxIssue] ADD  CONSTRAINT [DF_PMBoxIssue_PMCode]  DEFAULT ('') FOR [PMCode]
GO
ALTER TABLE [dbo].[PMBoxIssue] ADD  CONSTRAINT [DF_PMBoxIssue_CBM]  DEFAULT ((0)) FOR [CBM]
GO
ALTER TABLE [dbo].[PMCategories] ADD  CONSTRAINT [DF_PMCategories_PMCategory]  DEFAULT ('') FOR [PMCategory]
GO
ALTER TABLE [dbo].[PMCategoryEnPoints] ADD  CONSTRAINT [DF_PMCategoryEnPoints_PMCategory]  DEFAULT ('') FOR [PMCategory]
GO
ALTER TABLE [dbo].[PMCategoryEnPoints] ADD  CONSTRAINT [DF_PMCategoryEnPoints_EnPoint]  DEFAULT ('') FOR [EnPoint]
GO
ALTER TABLE [dbo].[PMIn] ADD  CONSTRAINT [DF_PMIn_InNo]  DEFAULT ('') FOR [InNo]
GO
ALTER TABLE [dbo].[PMIn] ADD  CONSTRAINT [DF_PMIn_Remarks]  DEFAULT ('') FOR [Remarks]
GO
ALTER TABLE [dbo].[PMIn] ADD  CONSTRAINT [DF_PMIn_EnterBy]  DEFAULT ('') FOR [EnterBy]
GO
ALTER TABLE [dbo].[PMIn] ADD  CONSTRAINT [DF_PMIn_UpdateBy]  DEFAULT ('') FOR [UpdateBy]
GO
ALTER TABLE [dbo].[PMIn] ADD  CONSTRAINT [DF_PMIn_PMSupplierCode]  DEFAULT ('') FOR [PMSupplierCode]
GO
ALTER TABLE [dbo].[PMIn] ADD  CONSTRAINT [DF_PMIn_IsCancelled]  DEFAULT ((0)) FOR [IsCancelled]
GO
ALTER TABLE [dbo].[PMInDtl] ADD  CONSTRAINT [DF_PMInDtl_InNo]  DEFAULT ('') FOR [InNo]
GO
ALTER TABLE [dbo].[PMInDtl] ADD  CONSTRAINT [DF_PMInDtl_PMCode]  DEFAULT ('') FOR [PMCode]
GO
ALTER TABLE [dbo].[PMInDtl] ADD  CONSTRAINT [DF_PMInDtl_PMQty]  DEFAULT ((0)) FOR [PMQty]
GO
ALTER TABLE [dbo].[PMInDtl] ADD  CONSTRAINT [DF_PMInDtl_CBM]  DEFAULT ((0)) FOR [CBM]
GO
ALTER TABLE [dbo].[PMIssueContract] ADD  CONSTRAINT [DF_PMIssueContract_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[PMIssueContract] ADD  CONSTRAINT [DF_PMIssueContract_PMCode]  DEFAULT ('') FOR [PMCode]
GO
ALTER TABLE [dbo].[PMIssueContract] ADD  CONSTRAINT [DF_PMIssueContract_IssueQty]  DEFAULT ((0)) FOR [IssueCBM]
GO
ALTER TABLE [dbo].[PMMaster] ADD  CONSTRAINT [DF_PMMaster_PMCode]  DEFAULT ('') FOR [PMCode]
GO
ALTER TABLE [dbo].[PMMaster] ADD  CONSTRAINT [DF_PMMaster_PMDescription]  DEFAULT ('') FOR [PMDescription]
GO
ALTER TABLE [dbo].[PMMaster] ADD  CONSTRAINT [DF_PMMaster_PMCategory]  DEFAULT ('') FOR [PMCategory]
GO
ALTER TABLE [dbo].[PMMaster] ADD  CONSTRAINT [DF_PMMaster_PMIssueType]  DEFAULT ('') FOR [PMIssueType]
GO
ALTER TABLE [dbo].[PMMaster] ADD  CONSTRAINT [DF_PMMaster_QtyInHand]  DEFAULT ((0)) FOR [QtyInHand]
GO
ALTER TABLE [dbo].[PMMaster] ADD  CONSTRAINT [DF_PMMaster_QtyReOrderLevel]  DEFAULT ((0)) FOR [QtyReOrderLevel]
GO
ALTER TABLE [dbo].[PMMaster] ADD  CONSTRAINT [DF_PMMaster_PMWgt]  DEFAULT ((0)) FOR [PMWgt]
GO
ALTER TABLE [dbo].[PMMaster] ADD  CONSTRAINT [DF_PMMaster_PMCBM]  DEFAULT ((0)) FOR [PMCBM]
GO
ALTER TABLE [dbo].[PMMaster] ADD  CONSTRAINT [DF_PMMaster_GetJokerCount]  DEFAULT ((0)) FOR [GetJokerCount]
GO
ALTER TABLE [dbo].[PMMaster] ADD  CONSTRAINT [DF_PMMaster_GetJokerCount1]  DEFAULT ((0)) FOR [GetPartCount]
GO
ALTER TABLE [dbo].[PMMaster] ADD  CONSTRAINT [DF_PMMaster_GetCtnCount]  DEFAULT ((0)) FOR [GetCtnCount]
GO
ALTER TABLE [dbo].[PMMaster] ADD  CONSTRAINT [DF_PMMaster_StockCBM]  DEFAULT ((0)) FOR [StockCBM]
GO
ALTER TABLE [dbo].[PMMaster] ADD  CONSTRAINT [DF_PMMaster_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[PMOut] ADD  CONSTRAINT [DF_PMOut_OutNo]  DEFAULT ('') FOR [OutNo]
GO
ALTER TABLE [dbo].[PMOut] ADD  CONSTRAINT [DF_PMOut_PMOutDate]  DEFAULT ('') FOR [PMOutDate]
GO
ALTER TABLE [dbo].[PMOut] ADD  CONSTRAINT [DF_PMOut_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[PMOut] ADD  CONSTRAINT [DF_PMOut_EnterBy]  DEFAULT ('') FOR [EnterBy]
GO
ALTER TABLE [dbo].[PMOut] ADD  CONSTRAINT [DF_PMOut_UpdateBy]  DEFAULT ('') FOR [UpdateBy]
GO
ALTER TABLE [dbo].[PMOutDtl] ADD  CONSTRAINT [DF_PMOutDtl_OutNo]  DEFAULT ('') FOR [OutNo]
GO
ALTER TABLE [dbo].[PMOutDtl] ADD  CONSTRAINT [DF_PMOutDtl_PMCode]  DEFAULT ('') FOR [PMCode]
GO
ALTER TABLE [dbo].[PMOutDtl] ADD  CONSTRAINT [DF_PMOutDtl_PMQty]  DEFAULT ((0)) FOR [PMQty]
GO
ALTER TABLE [dbo].[PMStockIssue] ADD  CONSTRAINT [DF_PMStockIssue_DateTime]  DEFAULT (NULL) FOR [DateAndTime]
GO
ALTER TABLE [dbo].[PMStockIssue] ADD  CONSTRAINT [DF_PMStockIssue_PMCode]  DEFAULT ('') FOR [PMCode]
GO
ALTER TABLE [dbo].[PMStockIssue] ADD  CONSTRAINT [DF_PMStockIssue_CBM]  DEFAULT ((0)) FOR [CBM]
GO
ALTER TABLE [dbo].[PMSupplier] ADD  CONSTRAINT [DF_PMSupplier_ShCode]  DEFAULT ('') FOR [PMSupplierCode]
GO
ALTER TABLE [dbo].[PMSupplier] ADD  CONSTRAINT [DF_PMSupplier_ShName]  DEFAULT ('') FOR [PMSupplierName]
GO
ALTER TABLE [dbo].[PMSupplier] ADD  CONSTRAINT [DF_PMSupplier_ShAdd1]  DEFAULT ('') FOR [PMSupplierAddress1]
GO
ALTER TABLE [dbo].[PMSupplier] ADD  CONSTRAINT [DF_PMSupplier_ShAdd2]  DEFAULT ('') FOR [PMSupplierAddress2]
GO
ALTER TABLE [dbo].[PMSupplier] ADD  CONSTRAINT [DF_PMSupplier_ShAdd3]  DEFAULT ('') FOR [PMSupplierAddress3]
GO
ALTER TABLE [dbo].[PMSupplier] ADD  CONSTRAINT [DF_PMSupplier_ShAdd4]  DEFAULT ('') FOR [PMSupplierAddress4]
GO
ALTER TABLE [dbo].[PMSupplier] ADD  CONSTRAINT [DF_PMSupplier_ShContact1]  DEFAULT ('') FOR [PMSupplierContact1]
GO
ALTER TABLE [dbo].[PMSupplier] ADD  CONSTRAINT [DF_PMSupplier_ShContact2]  DEFAULT ('') FOR [PMSupplierContact2]
GO
ALTER TABLE [dbo].[PMSupplier] ADD  CONSTRAINT [DF_PMSupplier_ShContact3]  DEFAULT ('') FOR [PMSupplierContact3]
GO
ALTER TABLE [dbo].[PMSupplier] ADD  CONSTRAINT [DF_PMSupplier_ShTel]  DEFAULT ('') FOR [PMSupplierTel]
GO
ALTER TABLE [dbo].[PMSupplier] ADD  CONSTRAINT [DF_PMSupplier_ShEmail]  DEFAULT ('') FOR [PMSupplierEmail]
GO
ALTER TABLE [dbo].[PMSupplier] ADD  CONSTRAINT [DF_PMSupplier_ShFax]  DEFAULT ('') FOR [PMSupplierFax]
GO
ALTER TABLE [dbo].[PMSupplier] ADD  CONSTRAINT [DF_PMSupplier_CountryCode]  DEFAULT ('') FOR [CountryCode]
GO
ALTER TABLE [dbo].[PMTemplate] ADD  CONSTRAINT [DF_PMTemplate_DC]  DEFAULT ('') FOR [DC]
GO
ALTER TABLE [dbo].[PMTemplate] ADD  CONSTRAINT [DF_PMTemplate_OrderNo]  DEFAULT ((0)) FOR [OrderNo]
GO
ALTER TABLE [dbo].[PMTemplate] ADD  CONSTRAINT [DF_PMTemplate_UnitType]  DEFAULT ('') FOR [UnitType]
GO
ALTER TABLE [dbo].[PMTemplate] ADD  CONSTRAINT [DF_PMTemplate_PMCode]  DEFAULT ('') FOR [PMCode]
GO
ALTER TABLE [dbo].[PMWastage] ADD  CONSTRAINT [DF_Table_1_InNo]  DEFAULT ('') FOR [PMWastageNo]
GO
ALTER TABLE [dbo].[PMWastage] ADD  CONSTRAINT [DF_PMWastage_Remarks]  DEFAULT ('') FOR [Remarks]
GO
ALTER TABLE [dbo].[PMWastage] ADD  CONSTRAINT [DF_PMWastage_EnterBy]  DEFAULT ('') FOR [EnterBy]
GO
ALTER TABLE [dbo].[PMWastage] ADD  CONSTRAINT [DF_PMWastage_UpdateBy]  DEFAULT ('') FOR [UpdateBy]
GO
ALTER TABLE [dbo].[PMWastage] ADD  CONSTRAINT [DF_PMWastage_IsCancelled]  DEFAULT ((0)) FOR [IsCancelled]
GO
ALTER TABLE [dbo].[PMWastageDtl] ADD  CONSTRAINT [DF_Table_1_InNo_1]  DEFAULT ('') FOR [PMWastageNo]
GO
ALTER TABLE [dbo].[PMWastageDtl] ADD  CONSTRAINT [DF_PMWastageDtl_PMCode]  DEFAULT ('') FOR [PMCode]
GO
ALTER TABLE [dbo].[PMWastageDtl] ADD  CONSTRAINT [DF_PMWastageDtl_PMQty]  DEFAULT ((0)) FOR [PMQty]
GO
ALTER TABLE [dbo].[Ports] ADD  CONSTRAINT [DF_Ports_PortCode]  DEFAULT ('') FOR [PortCode]
GO
ALTER TABLE [dbo].[Ports] ADD  CONSTRAINT [DF_Ports_PortName]  DEFAULT ('') FOR [PortName]
GO
ALTER TABLE [dbo].[Ports] ADD  CONSTRAINT [DF_Ports_CountryCode]  DEFAULT ('') FOR [CountryCode]
GO
ALTER TABLE [dbo].[Ports] ADD  CONSTRAINT [DF_Ports_CreateBy]  DEFAULT ('') FOR [CreateBy]
GO
ALTER TABLE [dbo].[Ports] ADD  CONSTRAINT [DF_Ports_UpdateBy]  DEFAULT ('') FOR [UpdateBy]
GO
ALTER TABLE [dbo].[Ports] ADD  CONSTRAINT [DF_Ports_SeaOrAirPort]  DEFAULT ('') FOR [SeaOrAirPort]
GO
ALTER TABLE [dbo].[Ports] ADD  CONSTRAINT [DF_Ports_IsDivertable]  DEFAULT ((0)) FOR [IsDivertable]
GO
ALTER TABLE [dbo].[PriceTagConfig] ADD  CONSTRAINT [DF_PriceTagConfig_Id]  DEFAULT ('') FOR [Id]
GO
ALTER TABLE [dbo].[PriceTagConfig] ADD  CONSTRAINT [DF_PriceTagConfig_TotLength]  DEFAULT ((0)) FOR [TotLength]
GO
ALTER TABLE [dbo].[PriceTagConfig] ADD  CONSTRAINT [DF_PriceTagConfig_Des]  DEFAULT ('') FOR [Des]
GO
ALTER TABLE [dbo].[PriceTagConfigDtl] ADD  CONSTRAINT [DF_PriceTagConfigDtl_Id]  DEFAULT ('') FOR [Id]
GO
ALTER TABLE [dbo].[PriceTagConfigDtl] ADD  CONSTRAINT [DF_PriceTagConfigDtl_OrderNo]  DEFAULT ((0)) FOR [OrderNo]
GO
ALTER TABLE [dbo].[PriceTagConfigDtl] ADD  CONSTRAINT [DF_PriceTagConfigDtl_PosFrom]  DEFAULT ((0)) FOR [PosFrom]
GO
ALTER TABLE [dbo].[PriceTagConfigDtl] ADD  CONSTRAINT [DF_PriceTagConfigDtl_PosTo]  DEFAULT ((0)) FOR [PosTo]
GO
ALTER TABLE [dbo].[PriceTagConfigDtl] ADD  CONSTRAINT [DF_PriceTagConfigDtl_Caption]  DEFAULT ('') FOR [Caption]
GO
ALTER TABLE [dbo].[PriceTagConfigDtl] ADD  CONSTRAINT [DF_PriceTagConfigDtl_Matching]  DEFAULT ((0)) FOR [Matching]
GO
ALTER TABLE [dbo].[PwInfo] ADD  CONSTRAINT [DF_PwInfo_PassWord]  DEFAULT ('') FOR [PassWord]
GO
ALTER TABLE [dbo].[PwInfo] ADD  CONSTRAINT [DF_PwInfo_Department]  DEFAULT ('') FOR [Department]
GO
ALTER TABLE [dbo].[PwInfo] ADD  CONSTRAINT [DF_PwInfo_UserLevel]  DEFAULT ('') FOR [UserLevel]
GO
ALTER TABLE [dbo].[PwInfo] ADD  CONSTRAINT [DF_PwInfo_UserName]  DEFAULT ('') FOR [UserName]
GO
ALTER TABLE [dbo].[PwInfo] ADD  CONSTRAINT [DF_PwInfo_IsNewOption]  DEFAULT ((0)) FOR [IsNewOption]
GO
ALTER TABLE [dbo].[PwInfo] ADD  CONSTRAINT [DF_PwInfo_IsEdit]  DEFAULT ((0)) FOR [IsEditOption]
GO
ALTER TABLE [dbo].[PwInfo] ADD  CONSTRAINT [DF_PwInfo_IsPrint]  DEFAULT ((0)) FOR [IsPrintOption]
GO
ALTER TABLE [dbo].[PwInfo] ADD  CONSTRAINT [DF_PwInfo_IsConfirmOption]  DEFAULT ((0)) FOR [IsConfirmOption]
GO
ALTER TABLE [dbo].[PwInfo] ADD  CONSTRAINT [DF_PwInfo_IsReConfirmOption]  DEFAULT ((0)) FOR [IsReConfirmOption]
GO
ALTER TABLE [dbo].[PwInfo] ADD  CONSTRAINT [DF_PwInfo_IsSignOption]  DEFAULT ((0)) FOR [IsSignOption]
GO
ALTER TABLE [dbo].[PwInfo] ADD  CONSTRAINT [DF_PwInfo_IsCancel]  DEFAULT ((0)) FOR [IsCancelOption]
GO
ALTER TABLE [dbo].[PwInfo] ADD  CONSTRAINT [DF_PwInfo_IsOtherOption]  DEFAULT ((0)) FOR [IsOtherOption]
GO
ALTER TABLE [dbo].[PwInfo] ADD  CONSTRAINT [DF_PwInfo_isConfirmAC]  DEFAULT ((0)) FOR [isConfirmAC]
GO
ALTER TABLE [dbo].[PwInfo] ADD  CONSTRAINT [DF_PwInfo_isReEdit]  DEFAULT ((0)) FOR [isReEdit]
GO
ALTER TABLE [dbo].[PwInfo] ADD  CONSTRAINT [DF_PwInfo_UserCategory]  DEFAULT ('') FOR [UserCategory]
GO
ALTER TABLE [dbo].[PwInfo] ADD  CONSTRAINT [DF_PwInfo_EmailAddress]  DEFAULT ('') FOR [EmailAddress]
GO
ALTER TABLE [dbo].[PwInfo] ADD  CONSTRAINT [DF_PwInfo_InitMenuId]  DEFAULT ('0') FOR [InitMenuId]
GO
ALTER TABLE [dbo].[PwInfo] ADD  CONSTRAINT [DF_PwInfo_InitController]  DEFAULT ('') FOR [InitController]
GO
ALTER TABLE [dbo].[PwInfo] ADD  CONSTRAINT [DF_PwInfo_InitAction]  DEFAULT ('') FOR [InitAction]
GO
ALTER TABLE [dbo].[PwInfoDC] ADD  CONSTRAINT [DF_PwInfoDC_UserId]  DEFAULT ('') FOR [UserId]
GO
ALTER TABLE [dbo].[PwInfoDC] ADD  CONSTRAINT [DF_PwInfoDC_DC]  DEFAULT ('') FOR [DC]
GO
ALTER TABLE [dbo].[PwInfoShippers] ADD  CONSTRAINT [DF_PwInfoShippers_UserId]  DEFAULT ('') FOR [UserId]
GO
ALTER TABLE [dbo].[PwInfoShippers] ADD  CONSTRAINT [DF_PwInfoShippers_ShipperCode]  DEFAULT ('') FOR [ShipperCode]
GO
ALTER TABLE [dbo].[QCStaff] ADD  CONSTRAINT [DF_QCStaff_StaffCode]  DEFAULT ('') FOR [StaffCode]
GO
ALTER TABLE [dbo].[QCStaff] ADD  CONSTRAINT [DF_QCStaff_StaffName]  DEFAULT ('') FOR [StaffName]
GO
ALTER TABLE [dbo].[QCStaff] ADD  CONSTRAINT [DF_QCStaff_EnterBy]  DEFAULT ('') FOR [EnterBy]
GO
ALTER TABLE [dbo].[QCStaff] ADD  CONSTRAINT [DF_QCStaff_UpdateBy]  DEFAULT ('') FOR [UpdateBy]
GO
ALTER TABLE [dbo].[RackBuild] ADD  CONSTRAINT [DF_RackBuild_RackNo]  DEFAULT ('') FOR [RackNo]
GO
ALTER TABLE [dbo].[RackBuild] ADD  CONSTRAINT [DF_RackBuild_LocationId]  DEFAULT ('') FOR [LocationId]
GO
ALTER TABLE [dbo].[RackBuild] ADD  CONSTRAINT [DF_RackBuild_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[RateCFSExport] ADD  CONSTRAINT [DF_RateCFSExport_ChgCode]  DEFAULT ('') FOR [ChgCode]
GO
ALTER TABLE [dbo].[RateCFSExport] ADD  CONSTRAINT [DF_RateCFSExport_ChgDescription]  DEFAULT ('') FOR [ChgDescription]
GO
ALTER TABLE [dbo].[RateCFSExport] ADD  CONSTRAINT [DF_Table_1_UnitType2]  DEFAULT ('') FOR [UnitType]
GO
ALTER TABLE [dbo].[RateCFSExport] ADD  CONSTRAINT [DF_RateCFSExport_FreeUnitType1]  DEFAULT ((0)) FOR [Range1]
GO
ALTER TABLE [dbo].[RateCFSExport] ADD  CONSTRAINT [DF_RateCFSExport_FreeUnitType]  DEFAULT ((0)) FOR [Range2]
GO
ALTER TABLE [dbo].[RateCFSExport] ADD  CONSTRAINT [DF_RateCFSExport_ContractGroupType]  DEFAULT ('') FOR [UnitCalType]
GO
ALTER TABLE [dbo].[RateCFSExport] ADD  CONSTRAINT [DF_RateCFSExport_RateInUSD]  DEFAULT ((0)) FOR [RateInUSD]
GO
ALTER TABLE [dbo].[RateCFSExport] ADD  CONSTRAINT [DF_RateCFSExport_isActive]  DEFAULT ((1)) FOR [isActive]
GO
ALTER TABLE [dbo].[RateCFSExport] ADD  CONSTRAINT [DF_RateCFSExport_fileCaption]  DEFAULT ('') FOR [FileCaption]
GO
ALTER TABLE [dbo].[RateCFSExport] ADD  CONSTRAINT [DF_RateCFSExport_MaterialCode]  DEFAULT ('') FOR [MaterialCode]
GO
ALTER TABLE [dbo].[RateCFSExport] ADD  CONSTRAINT [DF_RateCFSExport_RateinUSDCost]  DEFAULT ((0)) FOR [RateinUSDCost]
GO
ALTER TABLE [dbo].[RateCFSExport] ADD  CONSTRAINT [DF_RateCFSExport_RateUpdateBy]  DEFAULT ('') FOR [RateUpdateBy]
GO
ALTER TABLE [dbo].[RateClearHaulageExport] ADD  CONSTRAINT [DF_RateClearHaulageExport_CntrType]  DEFAULT ('') FOR [CntrType]
GO
ALTER TABLE [dbo].[RateClearHaulageExport] ADD  CONSTRAINT [DF_Table_1_Rate]  DEFAULT ((0)) FOR [RateInUSD]
GO
ALTER TABLE [dbo].[RateClearHaulageExport] ADD  CONSTRAINT [DF_RateClearHaulageExport_RateUpdateBy]  DEFAULT ('') FOR [RateUpdateBy]
GO
ALTER TABLE [dbo].[RateFreightExport] ADD  CONSTRAINT [DF_FreightRateExport_PortCode]  DEFAULT ('') FOR [PortCode]
GO
ALTER TABLE [dbo].[RateFreightExport] ADD  CONSTRAINT [DF_FreightRateExport_CntrType]  DEFAULT ('') FOR [CntrType]
GO
ALTER TABLE [dbo].[RateFreightExport] ADD  CONSTRAINT [DF_FreightRateExport_Rate]  DEFAULT ((0)) FOR [RateInUSD]
GO
ALTER TABLE [dbo].[RateFreightExport] ADD  CONSTRAINT [DF_RateFreightExport_RateUpdateBy]  DEFAULT ('') FOR [RateUpdateBy]
GO
ALTER TABLE [dbo].[RFIDData] ADD  CONSTRAINT [DF_RFIDData_ContractNo]  DEFAULT ('') FOR [ContractNo]
GO
ALTER TABLE [dbo].[RFIDData] ADD  CONSTRAINT [DF_RFIDData_DeliveryNo]  DEFAULT ((0)) FOR [DeliveryNo]
GO
ALTER TABLE [dbo].[RFIDData] ADD  CONSTRAINT [DF_RFIDData_ItemNo]  DEFAULT ('') FOR [ItemNo]
GO
ALTER TABLE [dbo].[RFIDData] ADD  CONSTRAINT [DF_RFIDData_DCMain_1]  DEFAULT ('') FOR [DCMain]
GO
ALTER TABLE [dbo].[RFIDData] ADD  CONSTRAINT [DF_RFIDData_GlobalBrand]  DEFAULT ('') FOR [GlobalBrand]
GO
ALTER TABLE [dbo].[RFIDData] ADD  CONSTRAINT [DF_RFIDData_GarmentType]  DEFAULT ('') FOR [GarmentType]
GO
ALTER TABLE [dbo].[RFIDData] ADD  CONSTRAINT [DF_RFIDData_Phase]  DEFAULT ('') FOR [Phase]
GO
ALTER TABLE [dbo].[RFIDData] ADD  CONSTRAINT [DF_RFIDData_SupplerRef]  DEFAULT ('') FOR [SupplierRef]
GO
ALTER TABLE [dbo].[RFIDData] ADD  CONSTRAINT [DF_RFIDData_ILSLookup]  DEFAULT ('') FOR [ItemOptionLookup]
GO
ALTER TABLE [dbo].[RFIDData] ADD  CONSTRAINT [DF_RFIDData_RFIDOrderd]  DEFAULT ('') FOR [RFIDOrderStatus]
GO
ALTER TABLE [dbo].[RFIDData] ADD  CONSTRAINT [DF_RFIDData_RFIDOrderBy]  DEFAULT ('') FOR [RFIDOrderBy]
GO
ALTER TABLE [dbo].[RFIDData] ADD  CONSTRAINT [DF_RFIDData_RFIDOrderRef]  DEFAULT ('') FOR [RFIDOrderRef]
GO
ALTER TABLE [dbo].[RFIDData] ADD  CONSTRAINT [DF_RFIDData_DC]  DEFAULT ('') FOR [DC]
GO
ALTER TABLE [dbo].[RFIDData] ADD  CONSTRAINT [DF_RFIDData_NofParts]  DEFAULT ((0)) FOR [NofParts]
GO
ALTER TABLE [dbo].[RFIDDataDtl] ADD  CONSTRAINT [DF_RFIDDataDtl_LotNo]  DEFAULT ('') FOR [ContractNo]
GO
ALTER TABLE [dbo].[RFIDDataDtl] ADD  CONSTRAINT [DF_RFIDDataDtl_DeliveryNo]  DEFAULT ((0)) FOR [DeliveryNo]
GO
ALTER TABLE [dbo].[RFIDDataDtl] ADD  CONSTRAINT [DF_RFIDDataDtl_ItemOption]  DEFAULT ('') FOR [ItemNo]
GO
ALTER TABLE [dbo].[RFIDDataDtl] ADD  CONSTRAINT [DF_RFIDDataDtl_ItemOption_1]  DEFAULT ('') FOR [ItemOption]
GO
ALTER TABLE [dbo].[RFIDDataDtl] ADD  CONSTRAINT [DF_RFIDDataDtl_DCMain]  DEFAULT ('') FOR [DCMain]
GO
ALTER TABLE [dbo].[RFIDDataDtl] ADD  CONSTRAINT [DF_RFIDDataDtl_PartSet]  DEFAULT ('') FOR [PartSet]
GO
ALTER TABLE [dbo].[RFIDDataDtl] ADD  CONSTRAINT [DF_RFIDDataDtl_EAN]  DEFAULT ('') FOR [EAN]
GO
ALTER TABLE [dbo].[RFIDDataDtl] ADD  CONSTRAINT [DF_RFIDDataDtl_ItemDes]  DEFAULT ('') FOR [ItemDes]
GO
ALTER TABLE [dbo].[RFIDDataDtl] ADD  CONSTRAINT [DF_Table_1_Size]  DEFAULT ('') FOR [ItemSize]
GO
ALTER TABLE [dbo].[RFIDDataDtl] ADD  CONSTRAINT [DF_RFIDDataDtl_ItemColor]  DEFAULT ('') FOR [ItemColor]
GO
ALTER TABLE [dbo].[RFIDDataDtl] ADD  CONSTRAINT [DF_RFIDDataDtl_RtlPrice]  DEFAULT ((0)) FOR [RtlPrice]
GO
ALTER TABLE [dbo].[RFIDDataDtl] ADD  CONSTRAINT [DF_RFIDDataDtl_Qty]  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[RFIDDataDtl] ADD  CONSTRAINT [DF_RFIDDataDtl_NofParts]  DEFAULT ((0)) FOR [NofParts]
GO
ALTER TABLE [dbo].[RFIDDataDtl] ADD  CONSTRAINT [DF_RFIDDataDtl_NofJokers]  DEFAULT ((0)) FOR [NofJokers]
GO
ALTER TABLE [dbo].[RFIDDataDtl] ADD  CONSTRAINT [DF_RFIDDataDtl_QtyBal]  DEFAULT ((0)) FOR [QtyBal]
GO
ALTER TABLE [dbo].[RFIDDataDtl] ADD  CONSTRAINT [DF_RFIDDataDtl_Department]  DEFAULT ('') FOR [Department]
GO
ALTER TABLE [dbo].[RFIDDataHangers] ADD  CONSTRAINT [DF_RFIDDataHangers_ItemOption]  DEFAULT ('') FOR [ItemOption]
GO
ALTER TABLE [dbo].[RFIDDataHangers] ADD  CONSTRAINT [DF_RFIDDataHangers_HangerQtyRequir]  DEFAULT ((0)) FOR [H497]
GO
ALTER TABLE [dbo].[RFIDDataHangers] ADD  CONSTRAINT [DF_RFIDDataHangers_H498]  DEFAULT ((0)) FOR [H498]
GO
ALTER TABLE [dbo].[RFIDDataHangers] ADD  CONSTRAINT [DF_RFIDDataHangers_H6008]  DEFAULT ((0)) FOR [H6008]
GO
ALTER TABLE [dbo].[RFIDDataHangers] ADD  CONSTRAINT [DF_RFIDDataHangers_H6010]  DEFAULT ((0)) FOR [H6010]
GO
ALTER TABLE [dbo].[RFIDDataHangers] ADD  CONSTRAINT [DF_RFIDDataHangers_H3315]  DEFAULT ((0)) FOR [H3315]
GO
ALTER TABLE [dbo].[RFIDEPCData] ADD  CONSTRAINT [DF_RFIDEPCData_OrferRef]  DEFAULT ('') FOR [OrderRef]
GO
ALTER TABLE [dbo].[RFIDEPCData] ADD  CONSTRAINT [DF_RFIDEPCData_EPCNo]  DEFAULT ('') FOR [EPCNo]
GO
ALTER TABLE [dbo].[RFIDEPCData] ADD  CONSTRAINT [DF_RFIDEPCData_EAN]  DEFAULT ('') FOR [EAN]
GO
ALTER TABLE [dbo].[RFIDEPCData] ADD  CONSTRAINT [DF_RFIDEPCData_StockVerify]  DEFAULT ((0)) FOR [StockVerify]
GO
ALTER TABLE [dbo].[RFIDEPCData] ADD  CONSTRAINT [DF_RFIDEPCData_Attach]  DEFAULT ((0)) FOR [Attach]
GO
ALTER TABLE [dbo].[RFIDOrderRef] ADD  CONSTRAINT [DF_RFIDOrderRef_Ref]  DEFAULT ('') FOR [OrderRef]
GO
ALTER TABLE [dbo].[RFIDOrderRef] ADD  CONSTRAINT [DF_RFIDOrderRef_OrderBy]  DEFAULT ('') FOR [OrderBy]
GO
ALTER TABLE [dbo].[RFIDOrderRef] ADD  CONSTRAINT [DF_RFIDOrderRef_RcvdEnterBy]  DEFAULT ('') FOR [RcvdEnterBy]
GO
ALTER TABLE [dbo].[RFIDOrderRef] ADD  CONSTRAINT [DF_RFIDOrderRef_EPCDataUpload]  DEFAULT ((0)) FOR [EPCDataUpload]
GO
ALTER TABLE [dbo].[RFIDOrderRef] ADD  CONSTRAINT [DF_RFIDOrderRef_EPCDataUploadBy]  DEFAULT ('') FOR [EPCDataUploadBy]
GO
ALTER TABLE [dbo].[RFIDOrderRef] ADD  CONSTRAINT [DF_RFIDOrderRef_StockVerifyStatus]  DEFAULT ('') FOR [StockVerifyStatus]
GO
ALTER TABLE [dbo].[RFIDOrderRef] ADD  CONSTRAINT [DF_RFIDOrderRef_DateLastUpdate]  DEFAULT ('') FOR [DateLastUpdate]
GO
ALTER TABLE [dbo].[RFIDOrderRef] ADD  CONSTRAINT [DF_RFIDOrderRef_Status]  DEFAULT ('') FOR [Status]
GO
ALTER TABLE [dbo].[SeaRates] ADD  CONSTRAINT [DF_Table_1_Stuffing40]  DEFAULT ((0)) FOR [Stuffing40_CBM]
GO
ALTER TABLE [dbo].[SeaRates] ADD  CONSTRAINT [DF_Table_1_Stuffing20]  DEFAULT ((0)) FOR [Stuffing20_CBM]
GO
ALTER TABLE [dbo].[SeaRates] ADD  CONSTRAINT [DF_Table_1_BLFee]  DEFAULT ((0)) FOR [BLFee_BL]
GO
ALTER TABLE [dbo].[SeaRates] ADD  CONSTRAINT [DF_SeaRates_Rigging_Bar]  DEFAULT ((0)) FOR [Rigging_Bar]
GO
ALTER TABLE [dbo].[SeaRates] ADD  CONSTRAINT [DF_Table_1_Hanging]  DEFAULT ((0)) FOR [Hanging_Bar]
GO
ALTER TABLE [dbo].[SeaRates] ADD  CONSTRAINT [DF_Table_1_Partion]  DEFAULT ((0)) FOR [Partion_Cntr]
GO
ALTER TABLE [dbo].[SeaRates] ADD  CONSTRAINT [DF_SeaRates_MgmtFee_20]  DEFAULT ((0)) FOR [MgmtFee_20]
GO
ALTER TABLE [dbo].[SeaRates] ADD  CONSTRAINT [DF_SeaRates_MgmtFee_40]  DEFAULT ((0)) FOR [MgmtFee_40]
GO
ALTER TABLE [dbo].[SeaRates] ADD  CONSTRAINT [DF_SeaRates_UpdatesBy]  DEFAULT ('') FOR [UpdateBy]
GO
ALTER TABLE [dbo].[ShipmentChangeTracking] ADD  CONSTRAINT [DF_ShipmentChangeTracking_RcvNo]  DEFAULT ('') FOR [RcvNo]
GO
ALTER TABLE [dbo].[ShipmentChangeTracking] ADD  CONSTRAINT [DF_ShipmentChangeTracking_DoneBy]  DEFAULT ('') FOR [DoneBy]
GO
ALTER TABLE [dbo].[ShipmentChangeTracking] ADD  CONSTRAINT [DF_ShipmentChangeTracking_Activity]  DEFAULT ('') FOR [Activity]
GO
ALTER TABLE [dbo].[ShipmentChangeTracking] ADD  CONSTRAINT [DF_ShipmentChangeTracking_Remarks]  DEFAULT ('') FOR [Remarks]
GO
ALTER TABLE [dbo].[ShipmentTypes] ADD  CONSTRAINT [DF_ShipmentTypes_ShipmentType]  DEFAULT ('') FOR [ShipmentType]
GO
ALTER TABLE [dbo].[ShipmentTypes] ADD  CONSTRAINT [DF_ShipmentTypes_QcYes]  DEFAULT ((0)) FOR [QcYes]
GO
ALTER TABLE [dbo].[Shipper] ADD  CONSTRAINT [DF_Shipper_ShCode]  DEFAULT ('') FOR [ShipperCode]
GO
ALTER TABLE [dbo].[Shipper] ADD  CONSTRAINT [DF_Shipper_ShName]  DEFAULT ('') FOR [ShipperName]
GO
ALTER TABLE [dbo].[Shipper] ADD  CONSTRAINT [DF_Shipper_ShAdd1]  DEFAULT ('') FOR [ShipperAddress1]
GO
ALTER TABLE [dbo].[Shipper] ADD  CONSTRAINT [DF_Shipper_ShAdd2]  DEFAULT ('') FOR [ShipperAddress2]
GO
ALTER TABLE [dbo].[Shipper] ADD  CONSTRAINT [DF_Shipper_ShAdd3]  DEFAULT ('') FOR [ShipperAddress3]
GO
ALTER TABLE [dbo].[Shipper] ADD  CONSTRAINT [DF_Shipper_ShAdd4]  DEFAULT ('') FOR [ShipperAddress4]
GO
ALTER TABLE [dbo].[Shipper] ADD  CONSTRAINT [DF_Shipper_ShContact1]  DEFAULT ('') FOR [ShipperContact1]
GO
ALTER TABLE [dbo].[Shipper] ADD  CONSTRAINT [DF_Shipper_ShContact2]  DEFAULT ('') FOR [ShipperContact2]
GO
ALTER TABLE [dbo].[Shipper] ADD  CONSTRAINT [DF_Shipper_ShContact3]  DEFAULT ('') FOR [ShipperContact3]
GO
ALTER TABLE [dbo].[Shipper] ADD  CONSTRAINT [DF_Shipper_CreateBy]  DEFAULT ('') FOR [CreateBy]
GO
ALTER TABLE [dbo].[Shipper] ADD  CONSTRAINT [DF_Shipper_UpdateBy]  DEFAULT ('') FOR [UpdateBy]
GO
ALTER TABLE [dbo].[Shipper] ADD  CONSTRAINT [DF_Shipper_ShCodeAir]  DEFAULT ('') FOR [ShipperCodeAir]
GO
ALTER TABLE [dbo].[Shipper] ADD  CONSTRAINT [DF_Shipper_ShCodeSea]  DEFAULT ('') FOR [ShipperCodeSea]
GO
ALTER TABLE [dbo].[Shipper] ADD  CONSTRAINT [DF_Shipper_ShTel]  DEFAULT ('') FOR [ShipperTel]
GO
ALTER TABLE [dbo].[Shipper] ADD  CONSTRAINT [DF_Shipper_ShEmail]  DEFAULT ('') FOR [ShipperEmail]
GO
ALTER TABLE [dbo].[Shipper] ADD  CONSTRAINT [DF_Shipper_ShFax]  DEFAULT ('') FOR [ShipperFax]
GO
ALTER TABLE [dbo].[Shipper] ADD  CONSTRAINT [DF_Shipper_CountryCode]  DEFAULT ('') FOR [CountryCode]
GO
ALTER TABLE [dbo].[Shipper] ADD  CONSTRAINT [DF_Shipper_LimaSupplierCode]  DEFAULT ('') FOR [LimaSupplierCode]
GO
ALTER TABLE [dbo].[Shipper] ADD  CONSTRAINT [DF_Shipper_REXNo]  DEFAULT ('') FOR [REXNo]
GO
ALTER TABLE [dbo].[SplitENADataSheet] ADD  CONSTRAINT [DF_SplitENADataSheet_ContractNo]  DEFAULT ('') FOR [ContractNo]
GO
ALTER TABLE [dbo].[SplitENADataSheet] ADD  CONSTRAINT [DF_SplitENADataSheet_DeliveryNo]  DEFAULT ((0)) FOR [DeliveryNo]
GO
ALTER TABLE [dbo].[SplitENADataSheet] ADD  CONSTRAINT [DF_SplitENADataSheet_ItemOption]  DEFAULT ('') FOR [ItemOption]
GO
ALTER TABLE [dbo].[SplitENADataSheet] ADD  CONSTRAINT [DF_SplitENADataSheet_EnterBy]  DEFAULT ('') FOR [EnterBy]
GO
ALTER TABLE [dbo].[SplitENADataSheet] ADD  CONSTRAINT [DF_SplitENADataSheet_IsSplited]  DEFAULT ((0)) FOR [IsSplited]
GO
ALTER TABLE [dbo].[SplitENADataSheet] ADD  CONSTRAINT [DF_SplitENADataSheet_IsChecked]  DEFAULT ((0)) FOR [IsChecked]
GO
ALTER TABLE [dbo].[StatusCodes] ADD  CONSTRAINT [DF_StatusTasks_StatusCode]  DEFAULT ('') FOR [StatusCode]
GO
ALTER TABLE [dbo].[StatusCodes] ADD  CONSTRAINT [DF_StatusTasks_StatusDes]  DEFAULT ('') FOR [StatusDes]
GO
ALTER TABLE [dbo].[TradeLanes] ADD  CONSTRAINT [DF_TradeLanes_TradeLane]  DEFAULT ('') FOR [TradeLane]
GO
ALTER TABLE [dbo].[TradeLanes] ADD  CONSTRAINT [DF_TradeLanes_CheckDuplicate]  DEFAULT ('ContractDelivery') FOR [CheckDuplicate]
GO
ALTER TABLE [dbo].[TradeLanes] ADD  CONSTRAINT [DF_TradeLanes_Delivery]  DEFAULT ('NonZero') FOR [Delivery]
GO
ALTER TABLE [dbo].[TradeLanes] ADD  CONSTRAINT [DF_TradeLanes_DeliveryAutoAdd]  DEFAULT ((0)) FOR [DeliveryAutoAdd]
GO
ALTER TABLE [dbo].[TradeLanes] ADD  CONSTRAINT [DF_TradeLanes_ContractLegth]  DEFAULT ((0)) FOR [ContractLegth]
GO
ALTER TABLE [dbo].[TradeLanes] ADD  CONSTRAINT [DF_TradeLanes_ItemLength]  DEFAULT ((0)) FOR [ItemLength]
GO
ALTER TABLE [dbo].[UserInfo] ADD  CONSTRAINT [DF_Table_1_UserName]  DEFAULT ('') FOR [UserId]
GO
ALTER TABLE [dbo].[UserInfo] ADD  CONSTRAINT [DF_UserInfo_UserName]  DEFAULT ('') FOR [UserName]
GO
ALTER TABLE [dbo].[UserInfo] ADD  CONSTRAINT [DF_UserInfo_UserEmail]  DEFAULT ('') FOR [UserEmail]
GO
ALTER TABLE [dbo].[UserInfo] ADD  CONSTRAINT [DF_UserInfo_UserCategory]  DEFAULT ('') FOR [UserCategory]
GO
ALTER TABLE [dbo].[VesselRegistry] ADD  CONSTRAINT [DF_VesselRegistry_VesselOrderNo]  DEFAULT ((0)) FOR [VesselOrderNo]
GO
ALTER TABLE [dbo].[VesselRegistry] ADD  CONSTRAINT [DF_VesselRegistry_VesselName]  DEFAULT ('') FOR [VesselName]
GO
ALTER TABLE [dbo].[VesselRegistry] ADD  CONSTRAINT [DF_VesselRegistry_Carrier]  DEFAULT ('') FOR [Carrier]
GO
ALTER TABLE [dbo].[VesselRegistry] ADD  CONSTRAINT [DF_VesselRegistry_VoyageNo]  DEFAULT ('') FOR [VoyageNo]
GO
ALTER TABLE [dbo].[VesselRegistry] ADD  CONSTRAINT [DF_VesselRegistry_DestPort]  DEFAULT ('') FOR [DestPort]
GO
ALTER TABLE [dbo].[VesselRegistry] ADD  CONSTRAINT [DF_VesselRegistry_LastContainerOrderNo]  DEFAULT ((0)) FOR [LastContainerOrderNo]
GO
ALTER TABLE [dbo].[VesselRegistry] ADD  CONSTRAINT [DF_VesselRegistry_VesselBookingNo]  DEFAULT ('') FOR [VesselBookingNo]
GO
ALTER TABLE [dbo].[VesselRegistry] ADD  CONSTRAINT [DF_VesselRegistry_EnterBy]  DEFAULT ('') FOR [EnterBy]
GO
ALTER TABLE [dbo].[VesselRegistry] ADD  CONSTRAINT [DF_VesselRegistry_UpdateBy]  DEFAULT ('') FOR [UpdateBy]
GO
ALTER TABLE [dbo].[VesselRegistry] ADD  CONSTRAINT [DF_VesselRegistry_Locked]  DEFAULT ((0)) FOR [Locked]
GO
ALTER TABLE [dbo].[VesselRegistry] ADD  CONSTRAINT [DF_VesselRegistry_LockedBy]  DEFAULT ('') FOR [LockedBy]
GO
ALTER TABLE [dbo].[VesselRegistry] ADD  CONSTRAINT [DF_VesselRegistry_SFOSJobNo]  DEFAULT ('') FOR [SFOSJobNo]
GO
ALTER TABLE [dbo].[VesselRegistry] ADD  CONSTRAINT [DF_VesselRegistry_SFOSJobNoEnterBy]  DEFAULT ('') FOR [SFOSJobNoEnterBy]
GO
ALTER TABLE [dbo].[VesselRegistry] ADD  CONSTRAINT [DF_VesselRegistry_SFOSJobConfirm]  DEFAULT ((0)) FOR [SFOSJobConfirm]
GO
ALTER TABLE [dbo].[VesselRegistry] ADD  CONSTRAINT [DF_VesselRegistry_SFOSJobConfirmBy]  DEFAULT ('') FOR [SFOSJobConfirmBy]
GO
ALTER TABLE [dbo].[VesselRegistry] ADD  CONSTRAINT [DF_VesselRegistry_VoyageNoLima]  DEFAULT ('') FOR [VoyageNoLima]
GO
ALTER TABLE [dbo].[VesselRegistry] ADD  CONSTRAINT [DF_VesselRegistry_MBLNo]  DEFAULT ('') FOR [MBLNo]
GO
ALTER TABLE [dbo].[VesselRegistry] ADD  CONSTRAINT [DF_VesselRegistry_DC]  DEFAULT ('') FOR [DC]
GO
ALTER TABLE [dbo].[VesselRegistry] ADD  CONSTRAINT [DF_VesselRegistry_CntrGateOut]  DEFAULT ((0)) FOR [CntrGateOut]
GO
ALTER TABLE [dbo].[VesselRegistry] ADD  CONSTRAINT [DF_VesselRegistry_DestReachStatus]  DEFAULT ('') FOR [DestReachStatus]
GO
ALTER TABLE [dbo].[VesselRegistry] ADD  CONSTRAINT [DF_VesselRegistry_DestReachBy]  DEFAULT ('') FOR [DestReachBy]
GO
ALTER TABLE [dbo].[VesselRegistry] ADD  CONSTRAINT [DF_VesselRegistry_DestCountry]  DEFAULT ('') FOR [DestCountry]
GO
ALTER TABLE [dbo].[VesselRegistry] ADD  CONSTRAINT [DF_VesselRegistry_ShipMode]  DEFAULT ('') FOR [ShipMode]
GO
ALTER TABLE [dbo].[VesselRegistryImport] ADD  CONSTRAINT [DF_VesselRegistryImport_VesselOrderNo]  DEFAULT ((0)) FOR [VesselOrderNo]
GO
ALTER TABLE [dbo].[VesselRegistryImport] ADD  CONSTRAINT [DF_VesselRegistryImport_VesselName]  DEFAULT ('') FOR [VesselName]
GO
ALTER TABLE [dbo].[VesselRegistryImport] ADD  CONSTRAINT [DF_VesselRegistryImport_Carrier]  DEFAULT ('') FOR [Carrier]
GO
ALTER TABLE [dbo].[VesselRegistryImport] ADD  CONSTRAINT [DF_VesselRegistryImport_VoyageNo]  DEFAULT ('') FOR [VoyageNo]
GO
ALTER TABLE [dbo].[VesselRegistryImport] ADD  CONSTRAINT [DF_VesselRegistryImport_DestPort]  DEFAULT ('') FOR [DestPort]
GO
ALTER TABLE [dbo].[VesselRegistryImport] ADD  CONSTRAINT [DF_VesselRegistryImport_LastContainerOrderNo]  DEFAULT ((0)) FOR [LastContainerOrderNo]
GO
ALTER TABLE [dbo].[VesselRegistryImport] ADD  CONSTRAINT [DF_VesselRegistryImport_VesselBookingNo]  DEFAULT ('') FOR [VesselBookingNo]
GO
ALTER TABLE [dbo].[VesselRegistryImport] ADD  CONSTRAINT [DF_VesselRegistryImport_EnterBy]  DEFAULT ('') FOR [EnterBy]
GO
ALTER TABLE [dbo].[VesselRegistryImport] ADD  CONSTRAINT [DF_VesselRegistryImport_UpdateBy]  DEFAULT ('') FOR [UpdateBy]
GO
ALTER TABLE [dbo].[VesselRegistryImport] ADD  CONSTRAINT [DF_VesselRegistryImport_Locked]  DEFAULT ((0)) FOR [Locked]
GO
ALTER TABLE [dbo].[VesselRegistryImport] ADD  CONSTRAINT [DF_VesselRegistryImport_LockedBy]  DEFAULT ('') FOR [LockedBy]
GO
ALTER TABLE [dbo].[VesselRegistryImport] ADD  CONSTRAINT [DF_VesselRegistryImport_VoyageNoLima]  DEFAULT ('') FOR [VoyageNoLima]
GO
ALTER TABLE [dbo].[VesselRegistryImport] ADD  CONSTRAINT [DF_VesselRegistryImport_MBLNo]  DEFAULT ('') FOR [MBLNo]
GO
ALTER TABLE [dbo].[VesselRegistryImport] ADD  CONSTRAINT [DF_VesselRegistryImport_ArrivalStatus]  DEFAULT ('') FOR [ArrivalStatus]
GO
ALTER TABLE [dbo].[VesselRegistryImport] ADD  CONSTRAINT [DF_VesselRegistryImport_ArrivalStatusBy]  DEFAULT ('') FOR [ArrivalStatusBy]
GO
ALTER TABLE [dbo].[VesselRegistryImport] ADD  CONSTRAINT [DF_VesselRegistryImport_CountryCode]  DEFAULT ('') FOR [CountryCode]
GO
ALTER TABLE [dbo].[VesselSeaRates] ADD  CONSTRAINT [DF_VesselSeaRates_VesselOrderNo]  DEFAULT ((0)) FOR [VesselOrderNo]
GO
ALTER TABLE [dbo].[VesselSeaRates] ADD  CONSTRAINT [DF_VesselSeaRates_Stuffing40_CBM]  DEFAULT ((0)) FOR [Stuffing40_CBM]
GO
ALTER TABLE [dbo].[VesselSeaRates] ADD  CONSTRAINT [DF_VesselSeaRates_Stuffing20_CBM]  DEFAULT ((0)) FOR [Stuffing20_CBM]
GO
ALTER TABLE [dbo].[VesselSeaRates] ADD  CONSTRAINT [DF_VesselSeaRates_BLFee_BL]  DEFAULT ((0)) FOR [BLFee_BL]
GO
ALTER TABLE [dbo].[VesselSeaRates] ADD  CONSTRAINT [DF_VesselSeaRates_Rigging_Bar]  DEFAULT ((0)) FOR [Rigging_Bar]
GO
ALTER TABLE [dbo].[VesselSeaRates] ADD  CONSTRAINT [DF_VesselSeaRates_Hanging_Bar]  DEFAULT ((0)) FOR [Hanging_Bar]
GO
ALTER TABLE [dbo].[VesselSeaRates] ADD  CONSTRAINT [DF_VesselSeaRates_Partion_Cntr]  DEFAULT ((0)) FOR [Partion_Cntr]
GO
ALTER TABLE [dbo].[VesselSeaRates] ADD  CONSTRAINT [DF_VesselSeaRates_MgmtFee_20]  DEFAULT ((0)) FOR [MgmtFee_20]
GO
ALTER TABLE [dbo].[VesselSeaRates] ADD  CONSTRAINT [DF_VesselSeaRates_MgmtFee_40]  DEFAULT ((0)) FOR [MgmtFee_40]
GO
/****** Object:  StoredProcedure [dbo].[AlarmDeviceUpdate]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AlarmDeviceUpdate]
(@DeviceName nvarchar(50), @DeviceStatus decimal)
AS
Update AlarmDevice SET
DeviceStatus=@DeviceStatus
where
DeviceName=@DeviceName


GO
/****** Object:  StoredProcedure [dbo].[BarCodeConfigAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[BarCodeConfigAdd]
(
@Id nvarchar(10), @TotLength decimal, @Des nvarchar(50)
)
AS
Set DateFormat DMY;
Insert Into
BarCodeConfig
(Id, TotLength, Des)
Values(@Id, @TotLength, @Des)



GO
/****** Object:  StoredProcedure [dbo].[BarCodeConfigDtlAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure
[dbo].[BarCodeConfigDtlAdd]
(
@Id nvarchar(10), @OrderNo decimal, @PosFrom decimal, @PosTo decimal, @Caption nvarchar(50), @Matching bit
)
As
SET DATEFORMAT DMY;
INSERT INTO 
BarCodeConfigDtl
(Id, OrderNo, PosFrom, PosTo, Caption, Matching)
Values(@Id, @OrderNo, @PosFrom, @PosTo, @Caption, @Matching)



GO
/****** Object:  StoredProcedure [dbo].[BarCodeConfigDtlEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure
[dbo].[BarCodeConfigDtlEdit]
(
@Id nvarchar(10), @OrderNo decimal, @PosFrom decimal, @PosTo decimal, @Caption nvarchar(50), @Matching bit
)
As
SET DATEFORMAT DMY;
UPDATE
BarCodeConfigDtl
SET
PosFrom=@PosFrom, 
PosTo=@PosTo, 
Caption=@Caption,
Matching=@Matching
where
Id=@Id and OrderNo=@OrderNo



GO
/****** Object:  StoredProcedure [dbo].[BarCodeConfigEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[BarCodeConfigEdit]
(
@Id nvarchar(10), @TotLength decimal, @Des nvarchar(50)
)
AS
Set DateFormat DMY;
Update
BarCodeConfig
Set

TotLength=@TotLength, 
Des=@Des
Where Id=@Id



GO
/****** Object:  StoredProcedure [dbo].[BookingSheetLastVesselOrderNoAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create   Procedure [dbo].[BookingSheetLastVesselOrderNoAdd]
(
@BookingDate DateTime,@LastVesselNo decimal
)
AS
SET DATEFORMAT DMY;
UPDATE 
BookingSheetLast
SET
LastVesselNo=@LastVesselNo
where
BookingDate=@BookingDate





GO
/****** Object:  StoredProcedure [dbo].[BookingSheetLastVesselOrderNoNew]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create   Procedure [dbo].[BookingSheetLastVesselOrderNoNew]
(
@BookingDate DateTime,@LastVesselNo decimal
)
AS
SET DATEFORMAT DMY;
Insert INTO BookingSheetLast
(BookingDate,LastVesselNo)
Values(@BookingDate,@LastVesselNo)





GO
/****** Object:  StoredProcedure [dbo].[CancelContainerTallySheetStatus]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CancelContainerTallySheetStatus]
    @BookingDate DATETIME,
    @VesselOrderNumber DECIMAL,
    @ContainerOrderNumber DECIMAL
AS
BEGIN
    -- Update the IsTallyUpload field to False where the conditions match
    UPDATE ContainerData
    SET IsTallyUpload = 0
    WHERE BookingDate = @BookingDate
      AND VesselOrderNo = @VesselOrderNumber
      AND ContainerOrderNo = @ContainerOrderNumber;
END
GO
/****** Object:  StoredProcedure [dbo].[CargoBarCodeAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  procedure [dbo].[CargoBarCodeAdd]
(@BarCode nvarchar(40), @RcvNo nvarchar(10)
)
AS
SET DATEFORMAT DMY;
Insert Into
CargoBarCode
(
BarCode, RcvNo
)
Values
(@BarCode, @RcvNo)




GO
/****** Object:  StoredProcedure [dbo].[CargoBarcodeCtnOutAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CargoBarcodeCtnOutAdd]
(
@RcvNo nvarchar(10), @BoxId nvarchar(5),@StoreCode nvarchar(10), @ItemOption nvarchar(10), @EAN nvarchar(50), @PackQty decimal, @CtnType  nvarchar(10), @CtnLength int, @CtnWidth int, @CtnHeight int, @CtnCBM money, @isNewBox bit
)
AS
insert into CargoBarcodeCtnOut
(RcvNo, BoxId,StoreCode, ItemOption, EAN, PackQty, CtnType, CtnLength, CtnWidth, CtnHeight, CtnCBM, isNewBox)
values (@RcvNo, @BoxId,@StoreCode, @ItemOption, @EAN, @PackQty, @CtnType, @CtnLength, @CtnWidth, @CtnHeight, @CtnCBM, @isNewBox)

--Update Store Qty
Update CargoStorePickPlan
set
PickedQty=PickedQty + @PackQty
where
rcvno=@rcvNo and ItemOption=@ItemOption

--Update PackQty

Update CargoReceived 
set
PackQty=PackQty+1,
PackPCS=PackPCS + @PackQty
where
RcvNo=@RcvNo
GO
/****** Object:  StoredProcedure [dbo].[CargoBarcodeCtnOutInDtlAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CargoBarcodeCtnOutInDtlAdd]
(
@RcvNo nvarchar(10), @BoxId nvarchar(5), @BoxScanManual char(1), @BarCode nvarchar(40), @PackQty decimal
)
AS
set DATEFORMAT DMY;
INSERT INTO CargoBarcodeCtnOutInDtl 
(RcvNo, BoxId, BoxScanManual, BarCode, PackQty)
values(@RcvNo, @BoxId, @BoxScanManual, @BarCode, @PackQty)
GO
/****** Object:  StoredProcedure [dbo].[CargoBarCodeDelete]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[CargoBarCodeDelete]
(
@RcvNo as nvarchar(10)
)
as 
Delete from Cargobarcode
where RcvNo=@RcvNo



GO
/****** Object:  StoredProcedure [dbo].[CargoBarcodeLoadAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[CargoBarcodeLoadAdd]
					  
(
@Barcode nvarchar(40), @RcvNo nvarchar(10), @Stataus nvarchar(10),@LoadTime datetime
)
AS
SET DATEFORMAT DMY;
Update CargoBarCode
set
Status=@Stataus,
loadTime=@loadtime
where
BarCode=@Barcode and RcvNo=@RcvNo




GO
/****** Object:  StoredProcedure [dbo].[CargoBarCodeLoadCancel]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[CargoBarCodeLoadCancel]
(
@RcvNo nvarchar(10)
)

AS
SET DATEFORMAT DMY;
Update CargoBarCode
SET
Status='',
UpNo='',
RtnNo='ToBeScan'
where
RcvNo=@RcvNo



GO
/****** Object:  StoredProcedure [dbo].[CargoBarCodePackClose]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CargoBarCodePackClose]
(
	@Length nvarchar(10),
	@Width nvarchar(10),
	@Height nvarchar(10),
	@BarCode nvarchar(40),
	@RcvNo nvarchar(10),
	@CtnType nvarchar(10), 
	@PackPCS decimal, 
	@BoxNo nvarchar(10),
	@PalletOrderNo decimal,
	@BarCodeAudit nvarchar(40),
	@PackCBM money,
	@PackWgt money,
	 @LastBoxNo int
)
AS
SET DATEFORMAT DMY;

DECLARE @AuditItemOption varchar(10);

-- Retrieve the ItemOption value from the CargoBarCode table
SELECT @AuditItemOption = ItemOption
FROM CargoBarCode
WHERE BarCode = @BarCodeAudit and RcvNo=@RcvNo;


if (@BoxNo='Original')
	begin
	UPDATE CargoBarCode
		set
		CtnLength=@Length,
		CtnWidth= @Width,
		CtnHeight=@Height,
		PackPCS=@PackPCS,
		CtnType=@CtnType,
		LPNBoxNo=@LastBoxNo
	where 
		RcvNo=@RcvNo 
		and BarCode=@BarCode
	end
else 
	begin
		INSERT INTO CargoBarCode
			(RcvNo,BarCode,ItemOption,CtnType,CtnLength,CtnWidth ,CtnHeight,PackPCS,PalletOrderNo,BarcodeAudit,LPNBoxNo)
		values
			(@RcvNo,@BarCode,@AuditItemOption,@CtnType,@Length,@Width,@Height,@PackPCS,@PalletOrderNo,@BarCodeAudit,@LastBoxNo)

			update CargoReceived					   
		set
			 PackCBM = CASE 
                 WHEN PackCBM = 0 THEN CBM + @PackCBM
                 ELSE PackCBM + @PackCBM 
              END,
			PackWgt=PackWgt+@PackWgt
		where
			RcvNo=@RcvNo

	end

	update CargoReceived
		set
			PackPCS=PackPCS+@PackPCS,
			PackQty=PackQty+1,
			LastPackBoxNo=@LastBoxNo
		where
			RcvNo=@RcvNo
GO
/****** Object:  StoredProcedure [dbo].[CargoBarCodePackReset]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CargoBarCodePackReset]
(
    @BarCode nvarchar(40),
    @RcvNo nvarchar(10),
    @CtnType nvarchar(10),
    @PackPCS decimal,
    @BoxNo nvarchar(10),
    @PalletOrderNo decimal,
    @BarCodeAudit nvarchar(40),
    @PackCBM money,
    @PackWgt money
)
AS
BEGIN
    SET NOCOUNT ON;
    SET DATEFORMAT DMY;

    IF (@BoxNo = 'Original')
    BEGIN
        -- Update logic for CargoBarCode table
        UPDATE CargoBarCode
        SET PackPCS = 0,
            CtnType = @CtnType
        WHERE RcvNo = @RcvNo AND BarCode = @BarCode;
    END
    ELSE
    BEGIN
        -- Delete logic for CargoBarCode table
        DELETE FROM CargoBarCode
        WHERE RcvNo = @RcvNo AND BarCode = @Barcode;
    END

    -- Delete rows from CargoBarcodePMUsage table based on conditions
    DELETE FROM CargoBarcodePMUsage
    WHERE RcvNo=@RcvNo and BarCode = @BarCode AND EntryPoint = 'PK' and BoxScanManual='S'; 

    -- Update CargoReceived table
    UPDATE CargoReceived
    SET PackPCS = PackPCS - @PackPCS,
        PackQty = PackQty - 1,
        PackCBM = CASE WHEN RcvNo = @RcvNo THEN PackCBM - @PackCBM ELSE PackCBM END,
        PackWgt = CASE WHEN RcvNo = @RcvNo THEN PackWgt - @PackWgt ELSE PackWgt END
    WHERE RcvNo = @RcvNo;
END
GO
/****** Object:  StoredProcedure [dbo].[CargoBarcodePickPackAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CargoBarcodePickPackAdd]
(
@RcvNo nvarchar(10),@BarCode nvarchar(40),@TotalPcs decimal,@PickPcs decimal,@ENA nvarchar(50),@ItemSize nvarchar(50),@ItemColor nvarchar(50),@ItemDes nvarchar(100),
@CtnType nvarchar(10),@CtnLength money,@CtnWidth money,@CtnHeight money,@PickPackEnterBy nvarchar(10),@ItemOption varchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE CargoBarCode
Set
TotalPcs=@TotalPcs,
PickPcs=@PickPcs,
ENA=@ENA,
ItemSize=@ItemSize,
ItemColor=@ItemColor,
ItemDes=@ItemDes,
CtnType=@CtnType,
CtnLength=@CtnLength,
CtnWidth=@CtnWidth,
CtnHeight=@CtnHeight,
PickPackEnterBy=@PickPackEnterBy,
PickPackEnterTime=GETDATE(),
ItemOption=@ItemOption
Where
RcvNo=@RcvNo and BarCode=@BarCode
GO
/****** Object:  StoredProcedure [dbo].[CargoBarcodePickPackEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CargoBarcodePickPackEdit]
(
@RcvNo nvarchar(10),@BarCode nvarchar(40),@PickPCS decimal,@PickPackEnterBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE CargoBarCode
Set
PickPCS=@PickPCS,
PickPackEnterBy=@PickPackEnterBy,
PickPackEnterTime=GETDATE()
Where
RcvNo=@RcvNo and BarCode=@BarCode
GO
/****** Object:  StoredProcedure [dbo].[CargoBarcodePickPCSAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CargoBarcodePickPCSAdd]
(
    @RcvNo nvarchar(10),
    @BarCode nvarchar(40),
    @PickPcs decimal,
    @JokerTagsShortage decimal,
    @RFIDShortage decimal
)
AS
BEGIN
    SET DATEFORMAT DMY;

    UPDATE CargoBarCode
    SET
        PickPcs = PickPcs + @PickPcs,
        PCSAddTime = GetDate(),
        MismatchPCS = MismatchPCS + @PickPcs,
        JokerTagsShortage = JokerTagsShortage + @JokerTagsShortage,
        RFIDShortage = RFIDShortage + @RFIDShortage
    WHERE
        RcvNo = @RcvNo AND BarCode = @BarCode;
END
















/****** Object:  StoredProcedure [dbo].[CargoManualBoxPCSAdd]    Script Date: 3/18/2024 12:35:13 PM ******/
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[CargoBarcodePickTagMissingPCSAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CargoBarcodePickTagMissingPCSAdd]
(
    @RcvNo nvarchar(10),
    @BarCode nvarchar(40),
    @PickPcs decimal,
    @JokerTagsShortage decimal,
    @RFIDShortage decimal
)
AS
SET DATEFORMAT DMY;

UPDATE CargoBarCode
SET
    PickPcs = PickPcs + @PickPcs,
    PCSAddTime = GetDate(),
    TagMissingPCS = TagMissingPCS + @PickPCS,
               JokerTagsShortage = JokerTagsShortage + @JokerTagsShortage,
    RFIDShortage = RFIDShortage + @RFIDShortage
WHERE
    RcvNo = @RcvNo
    AND BarCode = @BarCode






















/****** Object:  StoredProcedure [dbo].[CargoManualBoxTagMissingPCSAdd]    Script Date: 3/18/2024 1:03:53 PM ******/
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[CargoBarcodePickValidateAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CargoBarcodePickValidateAdd]
(
    @RcvNo nvarchar(10),
    @BarCode nvarchar(40),
    @TotalPcs decimal,
    @ValidatePCS decimal,
    @ENA nvarchar(50),
    @ItemSize nvarchar(50),
    @ItemColor nvarchar(50),
    @ItemDes nvarchar(50),
    @CtnType nvarchar(10),
    @CtnLength money,
    @CtnWidth money,
    @CtnHeight money,
    @ValidateEnterBy nvarchar(10),
    @SetItem bit,
    @NofParts decimal,
    @NofJokers decimal,
    @JokerTagsShortage decimal,
    @RFIDShortage decimal,
    @ItemOption varchar(10)           
)
AS
BEGIN
    SET DATEFORMAT DMY;

    -- Update CargoBarCode table
    UPDATE CargoBarCode
    SET
        TotalPcs = @TotalPcs,
        ValidatePCS = @ValidatePCS,
        ENA = @ENA,
        ItemSize = @ItemSize,
        ItemColor = @ItemColor,
        ItemDes = @ItemDes,
        CtnType = @CtnType,
        CtnLength = @CtnLength,
        CtnWidth = @CtnWidth,
        CtnHeight = @CtnHeight,
        ValidateEnterBy = @ValidateEnterBy,
        ValidateEnterTime = GETDATE(),
        SetItem = @SetItem,
        NofParts = @NofParts,
        NofJokers = @NofJokers,
        RFIDShortage = RFIDShortage + @RFIDShortage,
        JokerTagsShortage = JokerTagsShortage + @JokerTagsShortage,
        ItemOption = @ItemOption
    WHERE
        RcvNo = @RcvNo AND
        BarCode = @BarCode;

    -- Check if the first 8 characters of @BarCode match @ItemOption
    IF LEFT(@BarCode, 8) != @ItemOption
    BEGIN
        -- Check if a row exists in CargoItemOption table
        IF not EXISTS (
            SELECT 1
            FROM CargoItemOption
            WHERE RcvNo = @RcvNo AND ItemOption = RIGHT(@ItemOption,2)
        )
        --BEGIN
            -- Update existing row
            --UPDATE CargoItemOption
            --SET
            --    Ctns = Ctns + 1,
            --    PCS = PCS + @TotalPcs
            --WHERE
            --    RcvNo = @RcvNo AND
            --    ItemOption = RIGHT(@ItemOption,2);
        --END
		--ELSE
        BEGIN
            -- Insert new row
            INSERT INTO CargoItemOption (RcvNo, ItemOption, OptionSize, Ctns, PCS, ItemOptionJMB, CtnType, EnterDate)
            VALUES (
                @RcvNo,
                RIGHT(@ItemOption, 2),
				'',
                1,
                @TotalPcs,
                '',
                '',
                NULL
            );
        END
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[CargoBarcodePMUsageAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE pROCEDURE [dbo].[CargoBarcodePMUsageAdd]
(
@RcvNo nvarchar(10), @BoxScanManual char(1), @Barcode nvarchar(40), @PMCode nvarchar(12), @PMQty decimal,@EntryPoint nvarchar(2)
)
AS
SET DATEFORMAT DMY;
INSERT INTO CargoBarcodePMUsage
(RcvNo, BoxScanManual, Barcode, PMCode, PMQty,EntryPoint)
values(@RcvNo, @BoxScanManual, @Barcode, @PMCode, @PMQty,@EntryPoint)
GO
/****** Object:  StoredProcedure [dbo].[CargoBarcodePMUsageAddWithVerification]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CargoBarcodePMUsageAddWithVerification]
(
    @RcvNo nvarchar(10),
    @BoxScanManual char(1),
    @Barcode nvarchar(40),
    @PMCode nvarchar(12),
    @PMQty decimal,
    @EntryPoint nvarchar(2)
)
AS
BEGIN
    SET DATEFORMAT DMY;

    INSERT INTO CargoBarcodePMUsage
    (RcvNo, BoxScanManual, Barcode, PMCode, PMQty, EntryPoint, Verified)
    VALUES
    (@RcvNo, @BoxScanManual, @Barcode, @PMCode, @PMQty, @EntryPoint, 1);
	UPDATE PMMaster 
set
QtyInHand=QtyInHand-@PMQty
where
PMCode=@PMCode
END;
GO
/****** Object:  StoredProcedure [dbo].[CargoBarcodePMUsageContainerAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CargoBarcodePMUsageContainerAdd]
(
    @BookingDate datetime, 
    @VesselOrderNo decimal, 
    @ContainerOrderNo decimal, 
    @PMCode nvarchar(12), 
    @PMQty decimal,
    @EntryPoint nvarchar(2),
	@IssueDate datetime
)
AS
BEGIN
    SET DATEFORMAT DMY;

    INSERT INTO CargoBarcodePMUsageContainer
    (
		BookingDate,
		VesselOrderNumber,
		ContainerOrderNumber,
		PMCode,
		PMQty,
		EntryPoint,
		IssueDate
    )
    VALUES
    (
        @BookingDate,
		@VesselOrderNo,
		@ContainerOrderNo,
		@PMCode,
		@PMQty,
		@EntryPoint,
		@IssueDate
    );
END
GO
/****** Object:  StoredProcedure [dbo].[CargoBarcodePMUsageContainerRemove]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CargoBarcodePMUsageContainerRemove]
(
    @BookingDate DATETIME, 
    @VesselOrderNo DECIMAL, 
    @ContainerOrderNo DECIMAL
)
AS
BEGIN
    SET DATEFORMAT DMY;

    DELETE FROM CargoBarcodePMUsageContainer
    WHERE 
        BookingDate = @BookingDate
        AND VesselOrderNumber = @VesselOrderNo
        AND ContainerOrderNumber = @ContainerOrderNo;
END
GO
/****** Object:  StoredProcedure [dbo].[CargoBarCodeQCIn]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CargoBarCodeQCIn]
(
@BarCode nvarchar(40),@RcvNo nvarchar(10), @QCYes bit , @QCInTime datetime
)
AS 
SET DATEFORMAT DMY;
update CargoBarCode
set
QCYes=@QCYes,
QCInTime=@QCInTime
where
BarCode=@BarCode and RcvNo=@RcvNo


GO
/****** Object:  StoredProcedure [dbo].[CargoBarCodeRemoveAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[CargoBarCodeRemoveAdd]
(
@BarCode nvarchar(400)
)
AS
SET DATEFORMAT DMY;
UPDATE CargoBarCode
SET
Status='Remove'
where
BarCode=@BarCode



GO
/****** Object:  StoredProcedure [dbo].[CargoBarCodeSplitAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[CargoBarCodeSplitAdd]
(
@BarCode nvarchar(400),@RcvNoNew nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE CargoBarCode
SET
RcvNo=@RcvNoNew
where
BarCode=@BarCode



GO
/****** Object:  StoredProcedure [dbo].[CargoBarCodeStorePackDone]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[CargoBarCodeStorePackDone]
(
@RcvNo nvarchar(10),@BarCode nvarchar(40),@PCS decimal,@PickPackEnterBy nvarchar(10)
)
AS
Update CargoBarcode
set 
PickPcs=@PCS,
PackPCS=@PCS,
PickPackEnterBy=@PickPackEnterBy,
PickPackEnterTime=getdate()
where
RcvNo=@RcvNo and BarCode=@BarCode
GO
/****** Object:  StoredProcedure [dbo].[CargoBarCodeUploadAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE    procedure [dbo].[CargoBarCodeUploadAdd]
(@BarCode nvarchar(40), @Status nvarchar(10), @UpNo nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE CargoBarCode
set 
Status=@Status,
UpNo=@UpNo
where
BarCode=@BarCode






GO
/****** Object:  StoredProcedure [dbo].[CargoBarcodeValidatePCSAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CargoBarcodeValidatePCSAdd]
(
@RcvNo nvarchar(10),@BarCode nvarchar(40),@PickPcs decimal
)
AS
SET DATEFORMAT DMY;
UPDATE CargoBarCode
Set
ValidatePCS=ValidatePCS +@PickPcs,
PCSAddTime=GetDate(),
MismatchPCS=MismatchPCS+@PickPCS
Where
RcvNo=@RcvNo and BarCode=@BarCode
GO
/****** Object:  StoredProcedure [dbo].[CargoDueFlowupAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CargoDueFlowupAdd]
(
@RcvNo varchar(10), @DueTask char(1)
)
AS
SET DATEFORMAT DMY;
INSERT INTO CargoDueFlowup
(RcvNo, DueTask, DateRecord)
values(@RcvNo,@DueTask,GetDATE())
GO
/****** Object:  StoredProcedure [dbo].[CargoDueFlowUpDtlAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[CargoDueFlowUpDtlAdd]
(
@RcvNo varchar(10), @DueTask char(1),@ReasonId int
)
AS
SET DATEFORMAT DMY;
INSERT INTO CargoDueFlowUpDtl
(RcvNo, DueTask, ReasonId)
values(@RcvNo, @DueTask, @ReasonId)
GO
/****** Object:  StoredProcedure [dbo].[CargoDueFlowupFlowUp]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[CargoDueFlowupFlowUp]
(
@RcvNo varchar(10), @DueTask char(1)
)
AS
SET DATEFORMAT DMY;
UPDATE CargoDueFlowup
SET 
DateFlowup=GetDate(),
NofFlowUp=NofFlowUp+1
where 
RcvNo=@RcvNo and DueTask=@DueTask
GO
/****** Object:  StoredProcedure [dbo].[CargoItemOptionAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CargoItemOptionAdd]
(
@RcvNo nvarchar(10), @ItemOption nvarchar(10), @OptionSize nvarchar(20),@Ctns decimal,@PCS decimal,@CtnType nvarchar(20)
)
AS
BEGIN
    SET DATEFORMAT DMY;

    -- Check if the record with the same RcvNo and ItemOption already exists
    IF NOT EXISTS (
        SELECT 1 
        FROM CargoItemOption 
        WHERE RcvNo = @RcvNo 
        AND ItemOption = @ItemOption
    )
    BEGIN
        -- Insert only if the record does not exist
        INSERT INTO CargoItemOption (RcvNo, ItemOption, OptionSize, Ctns, PCS, CtnType, EnterDate)
        VALUES (@RcvNo, @ItemOption, @OptionSize, @Ctns, @PCS, @CtnType, GETDATE());
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[CargoItemOptionRFIDAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CargoItemOptionRFIDAdd]
(
@ContractNo varchar(20), @DeliveryNo decimal, @ItemOption varchar(10), @OptionSize varchar(20), @PCS decimal
)
AS
BEGIN
 -- Check if the record with the same ContractNo, DeliveryNo and ItemOption already exists
  IF NOT EXISTS (
        SELECT 1 
        FROM CargoItemOptionRFID
        WHERE ContractNo = @ContractNo
		AND 
		DeliveryNo=@DeliveryNo
        AND ItemOption = @ItemOption
    )
    BEGIN
	 -- Insert only if the record does not exist
	SET DATEFORMAT DMY;
	INSERT INTO CargoItemOptionRFID
	(ContractNo, DeliveryNo, ItemOption, OptionSize, PCS, EnterDate)
	values(@ContractNo, @DeliveryNo, @ItemOption, @OptionSize, @PCS, GETDATE())
	END
END
GO
/****** Object:  StoredProcedure [dbo].[CargoManualBoxAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CargoManualBoxAdd]
(
@RcvNo nvarchar(10), @CtnNo decimal, @BarCode nvarchar(40), @TotalPcs decimal, @PickPcs decimal, @ENA nvarchar(50), @ItemSize nvarchar(50), @ItemColor nvarchar(50), @ItemDes nvarchar(100), @PickPackEnterBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;
INSERT INTO CargoManualBox
(RcvNo, CtnNo, BarCode,ItemOption, TotalPcs, PickPcs, ENA, ItemSize, ItemColor, ItemDes, PickPackEnterBy, PickPackEnterTime)
Values
(@RcvNo, @CtnNo, @BarCode,left(@BarCode,8), @TotalPcs, @PickPcs, @ENA, @ItemSize, @ItemColor, @ItemDes, @PickPackEnterBy, getDate())
GO
/****** Object:  StoredProcedure [dbo].[CargoManualBoxAddValidate]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CargoManualBoxAddValidate]
(
    @RcvNo nvarchar(10),
	@ItemOption  varchar(11),
    @CtnNo decimal,
    @BarCode nvarchar(40),
    @TotalPcs decimal,
    @ValidatePCS decimal,
    @ENA nvarchar(50),
    @ItemSize nvarchar(50),
    @ItemColor nvarchar(50),
    @ItemDes nvarchar(100),
    @ValidateEnterBy nvarchar(10),
    @SetItem bit,
    @NofParts decimal,
    @NofJokers decimal,
    @JokerTagsShortage decimal,
    @RFIDShortage decimal            
)
AS
BEGIN
    SET DATEFORMAT DMY;

    INSERT INTO CargoManualBox
   (RcvNo, CtnNo, BarCode,ItemOption, TotalPcs, ValidatePCS, ENA, ItemSize, ItemColor, ItemDes, ValidateEnterBy, ValidateEnterTime, SetItem, NofParts, NofJokers, RFIDShortage, JokerTagsShortage)
    VALUES
    (@RcvNo, @CtnNo, @BarCode,@ItemOption, @TotalPcs, @ValidatePCS, @ENA, @ItemSize, @ItemColor, @ItemDes, @ValidateEnterBy, GETDATE(), @SetItem, @NofParts, @NofJokers, @RFIDShortage, @JokerTagsShortage)
END















/****** Object:  StoredProcedure [dbo].[CargoBarcodePickPCSAdd]    Script Date: 3/18/2024 12:28:40 PM ******/
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[CargoManualBoxPCSAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CargoManualBoxPCSAdd]
(
    @RcvNo nvarchar(10),
    @CtnNo decimal,
    @BarCode nvarchar(40),
    @PickPcs decimal,
    @JokerTagsShortage decimal,
    @RFIDShortage decimal
)
AS
BEGIN
    SET DATEFORMAT DMY;

    UPDATE CargoManualBox
    SET 
        PickPcs = PickPcs + @PickPCS,
        PCSAddTime = GetDate(),
        MismatchPCS = MismatchPCS + @PickPCS,
        JokerTagsShortage = JokerTagsShortage + @JokerTagsShortage,
        RFIDShortage = RFIDShortage + @RFIDShortage
    WHERE
        RcvNo = @RcvNo AND CtnNo = @CtnNo; --and Barcode = @BarCode
END













/****** Object:  StoredProcedure [dbo].[CargoBarcodePickTagMissingPCSAdd]    Script Date: 3/18/2024 1:01:26 PM ******/
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[CargoManualBoxPickPackEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CargoManualBoxPickPackEdit]
(
@RcvNo nvarchar(10), @CtnNo decimal,@PickPackEnterBy nvarchar(10), @BarCode nvarchar(40), @PickPcs decimal
)
AS
SET DATEFORMAT DMY;
Update CargoManualBox
SET 
PickPcs=@PickPCS,
PickPackEnterBy=@PickPackEnterBy,
PickPackEnterTime=GetDate()
where
RcvNo=@RcvNo and CtnNo=@CtnNo --and Barcode=@BarCode
GO
/****** Object:  StoredProcedure [dbo].[CargoManualBoxStorePackDone]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[CargoManualBoxStorePackDone]
(
@RcvNo nvarchar(10),@BarCode nvarchar(40),@PCS decimal,@PickPackEnterBy nvarchar(10)
)
AS
Update CargoManualBox
set 
PickPcs=@PCS,
PackPCS=@PCS,
PickPackEnterBy=@PickPackEnterBy,
PickPackEnterTime=getdate()
where
RcvNo=@RcvNo and BarCode=@BarCode
GO
/****** Object:  StoredProcedure [dbo].[CargoManualBoxTagMissingPCSAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CargoManualBoxTagMissingPCSAdd]
(
    @RcvNo nvarchar(10),
    @CtnNo decimal,
    @BarCode nvarchar(40),
    @PickPcs decimal,
    @JokerTagsShortage decimal,
    @RFIDShortage decimal
)
AS
SET DATEFORMAT DMY;

UPDATE CargoManualBox
SET 
    PickPcs = PickPcs + @PickPCS,
    PCSAddTime = GetDate(),
    TagMissingPCS = TagMissingPCS + @PickPCS,
               JokerTagsShortage = JokerTagsShortage + @JokerTagsShortage,
    RFIDShortage = RFIDShortage + @RFIDShortage
WHERE
    RcvNo = @RcvNo
    AND Barcode = @BarCode
GO
/****** Object:  StoredProcedure [dbo].[CargoManualBoxValidatePCSAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  procedure [dbo].[CargoManualBoxValidatePCSAdd]
(
@RcvNo nvarchar(10), @CtnNo decimal, @BarCode nvarchar(40), @PickPcs decimal
)
AS
SET DATEFORMAT DMY;
Update CargoManualBox
SET 
ValidatePCS=ValidatePCS+ @PickPCS,
PCSAddTime=GetDate(),
MismatchPCS=MismatchPCS+@PickPCS
where
RcvNo=@RcvNo and CtnNo=@CtnNo --and Barcode=@BarCode
GO
/****** Object:  StoredProcedure [dbo].[CargoManualPackClose]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[CargoManualPackClose]
(
	@Length nvarchar(10),
	@Width nvarchar(10),
	@Height nvarchar(10),
    @BarCode nvarchar(40), 
    @RcvNo nvarchar(10),
    @boxId decimal,
    @CtnType nvarchar(10), 
    @PackPCS decimal, 
    @BoxNo nvarchar(10),
    @PalletOrderNo decimal,
    @BarCodeAudit varchar(40),
    @PackCBM money,
    @PackWgt money,
	@LastBoxNo INT
)
AS
BEGIN
    SET DATEFORMAT DMY;

	DECLARE @AuditItemOption varchar(10);

	-- Retrieve the ItemOption value from the CargoBarCode table
	SELECT @AuditItemOption = ItemOption
	FROM CargoManualBox
	WHERE BarCode = @BarCodeAudit and RcvNo=@RcvNo;



    IF (@BoxNo = 'Original')
    BEGIN
        UPDATE CargoManualBox
        SET
			CtnLength=@Length,
			CtnWidth= @Width,
			CtnHeight=@Height,
            PackPCS = @PackPCS,
			LPNBoxNo=@LastBoxNo
        WHERE RcvNo = @RcvNo AND BarCode = @BarCode
    END
    ELSE 
    BEGIN
        INSERT INTO CargoManualBox
        (
            RcvNo,
            CtnNo,
            BarCode,
			ItemOption,
            PackPCS, 
            BarcodeAudit,
			LPNBoxNo,
			CtnLength,
			CtnWidth ,
			CtnHeight
        )
        VALUES
        (
            @RcvNo,
            @boxId,
            @BarCode, 
			@AuditItemOption, 
            @PackPCS, 
            @BarCodeAudit,
			@LastBoxno,
			@Length,
			@Width,
			@Height
        )
    END

    UPDATE CargoReceived
    SET
        PackPCS = PackPCS + @PackPCS,
        PackQty = PackQty + 1,
        PackCBM = PackCBM + @PackCBM,
        PackWgt = PackWgt + @PackWgt,
		LastPackBoxNo=@LastBoxNo
    WHERE
        RcvNo = @RcvNo
END
GO
/****** Object:  StoredProcedure [dbo].[CargoPicsAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CargoPicsAdd]
(
@PicEvent nvarchar(15), @GrnNo nvarchar(10), @VesselDate DateTime, @VesselOrderNo decimal, @ContainerOrderNo decimal, @BookingNo nvarchar(10), @OuterBarcode nvarchar(50), @PicFileName nvarchar(200), @PicFileFullPath nvarchar(200)
)
AS
SET DATEFORMAT DMY;
INSERT INTO  CargoPics
(PicEvent, GrnNo, VesselDate, VesselOrderNo, ContainerOrderNo, BookingNo, OuterBarcode, PicFileName, PicFileFullPath)
values(@PicEvent, @GrnNo, @VesselDate, @VesselOrderNo, @ContainerOrderNo, @BookingNo, @OuterBarcode, @PicFileName, @PicFileFullPath)
GO
/****** Object:  StoredProcedure [dbo].[CargoQCAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   procedure
[dbo].[CargoQCAdd]
(
@RcvNo nvarchar(10), @OrderNo decimal, @QCResult nvarchar(10), @QCRemark nvarchar(10), @QCDate datetime, @QCBy nvarchar(10), @DateEnter datetime , @QCShippingMode nvarchar(10), @Final bit
)
As
SET Dateformat dmy;
Insert Into CargoQC


(RcvNo, OrderNo, QCResult, QCRemark, QCDate, QCBy, DateEnter,QCShippingMode, Final)
Values
(@RcvNo, @OrderNo, @QCResult, @QCRemark, @QCDate, @QCBy, @DateEnter, @QCShippingMode, @Final)





GO
/****** Object:  StoredProcedure [dbo].[CargoQCEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  procedure [dbo].[CargoQCEdit]
(
@RcvNo nvarchar(10), @OrderNo decimal, @QCResult nvarchar(10), @QCRemark nvarchar(50), @QCDate datetime,@QCBy nvarchar(5), @DateUpdate datetime, @UpdateBy nvarchar(5), @QCShippingMode nvarchar(10), @Final bit
)
AS
SET DATEFORMAT DMY;
UPDATE
CargoQC
SET
QCResult=@QCResult,
QCRemark=@QCRemark,
QCDate=@QCDate,
QCBy=@QCBy,
DateUpdate=@DateUpdate,
UpdateBy=@UpdateBy,
QCShippingMode=@QCShippingMode,
Final=@Final
Where
RcvNo=@RcvNo and OrderNo=@OrderNo




GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedAcceptance]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[CargoReceivedAcceptance]
(
@RcvNo nvarchar(10),@GrnNo nvarchar(10),@IntakeStatus nvarchar(10),@IntakeTime DateTime,@IntakeTimeSys DateTime , @IntakeStatusBy nvarchar(10)
)
AS
SET DATEFORMAT DMY
UPDATE CargoReceived 
SET 
GrnNo=@GrnNo,
IntakeStatus=@IntakeStatus,
IntakeTime=@IntakeTime,
IntakeTimeSys=@IntakeTimeSys,
IntakeStatusBy=@IntakeStatusBy
Where RcvNo=@RcvNo
GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedAddManual]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE       procedure [dbo].[CargoReceivedAddManual]
(
@RcvNo nvarchar(10), @RcvDate datetime, @RcvTime datetime, @ShipperCode nvarchar(5), @ContractNo nvarchar(50), @ItemNo nvarchar(50), @InvoiceNo nvarchar(50), @PONo nvarchar(50), @DeliveryNo decimal, @ShippingMode nvarchar(10), @CargoType nvarchar(10), @Ctns decimal , @Pcs decimal, @LorryNo nvarchar(50), @QCType nvarchar(10), @CBM money, @TradeLane nvarchar(10), @Country nvarchar(10),@ScanQty decimal, @isManualIn bit,@IntakeComments nvarchar(200),@enterDate datetime, @EnterBy nvarchar(10), @InQty decimal
)
AS
SET Dateformat DMY;
Insert Into
CargoReceived
(RcvNo , RcvDate, RcvTime, ShipperCode, ContractNo, ItemNo , InvoiceNo, PONo , DeliveryNo, ShippingMode, CargoType , Ctns , Pcs , LorryNo , QCType , ShippingModeIn,CBM,CtnsIn , PcsIn ,CBMIn,DeliveryNoIn,TradeLane, Country, ScanQty, isManualIn,tradelanein, CountryIn,IntakeComments,EnterDate,EnterBy,InQty,EntryType,IntakeStatus,IntakeStatusBy,IntakeTime,IntakeTimeSys,UnloadStatus,UnloadBy,UnloadTimeSys)
Values
(@RcvNo , @RcvDate, @RcvTime, @ShipperCode, @ContractNo, @ItemNo , @InvoiceNo, @PONo , @DeliveryNo, @ShippingMode, @CargoType , @Ctns , @Pcs , @LorryNo , @QCType ,@ShippingMode,@CBM,@Ctns , @Pcs ,@CBM,@DeliveryNo,@TradeLane, @Country,@ScanQty, @isManualIn,@TradeLane, @Country,@IntakeComments,@enterDate,@EnterBy,@InQty,'Manual','Update',@EnterBy,@RcvTime,@RcvTime,'Update',@EnterBy,@RcvTime)










GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedAirRtnAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure 
[dbo].[CargoReceivedAirRtnAdd]
(
@RcvNo nvarchar(10), @RemoveDoneDate datetime, @RemoveDoneBy nvarchar(10),@RemoveType nvarchar(10), @RemovalComments nvarchar(200), @RemoveQty decimal, @LorryNoLoad nvarchar(50)
)
AS
SET DATEFORMAT DMY;
UPDATE CargoReceived
set
RemoveDoneDate=@RemoveDoneDate,
RemoveDoneBy=@RemoveDoneBy,
RemoveType=@RemoveType,
RemovalComments=@RemovalComments,
RemoveQty=RemoveQty+@RemoveQty,
LorryNoLoad=@LorryNoLoad
where
Rcvno=@RcvNo


GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedAuthorizationAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[CargoReceivedAuthorizationAdd]
(
@RcvNo nvarchar(10),@Authorized bit
)

AS
SET DATEFORMAT DMY;
Update CargoReceived
SET
Authorized=@Authorized,
AuthDate= CAST(GETDATE() As Date),
AuthTime=GETDATE()
where
RcvNo=@RcvNo


GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedBookingAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CargoReceivedBookingAdd]
(
@RcvNo nvarchar(10),@InboundBookingType nvarchar(10),@CargoFrom nvarchar(10),@InboundBookingDate Datetime,@InboundETD Datetime,@InboundVesselOrderNo decimal,
@InboundContainerOrderNo Decimal,@ShipperCode nvarchar(10),@ContractNo nvarchar(50),@DeliveryNo decimal,@ItemNo nvarchar(50),@ShippingMode nvarchar(10),@CargoType nvarchar(10),
@Ctns decimal, @PCS decimal, @CBM money, @GrossWgt money, @Country nvarchar(20),@Warehouse nvarchar(50),@TradeLane nvarchar(20),@CusdecNo nvarchar(50)
)
AS
SET DateFORMAT DMY;
INSERT INTO CargoReceived
(RcvNo,InboundBookingType,CargoFrom,InboundBookingDate,InboundETD,InboundVesselOrderNo,InboundContainerOrderNo,ShipperCode,ContractNo,DeliveryNo,ItemNo,ShippingMode,CargoType,Ctns,PCS,CBM,GrossWgt,Country,Warehouse,TradeLane,CusdecNo)
values(@RcvNo,@InboundBookingType,@CargoFrom,@InboundBookingDate,@InboundETD,@InboundVesselOrderNo,@InboundContainerOrderNo,@ShipperCode,@ContractNo,@DeliveryNo,@ItemNo,@ShippingMode,@CargoType,@Ctns,@PCS,@CBM,@GrossWgt,@Country,@Warehouse,@TradeLane,@CusdecNo)


UPDATE cr
SET cr.RfidOrder = rd.RFIDOrderStatus,
    cr.RfidOrderDate = rd.RFIDOrderDate,
    cr.RfidAvailableDate = rd.RfidAvailableDate
FROM CargoReceived cr
JOIN RFIDData rd
ON cr.ContractNo = rd.ContractNo
AND cr.DeliveryNo = rd.DeliveryNo
where
cr.RcvNo=@RcvNo
GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedChangeLoadingRef]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[CargoReceivedChangeLoadingRef]
(
@RcvNo as nvarchar(10), @LoadingRefChangeBy nvarchar(10), @LoadingRefChangeTime datetime
)
AS
SET DateFormat DMY;
UPDATE CargoReceived
SET
loadingRef=' ',
LoadingRefChangeBy=@LoadingRefChangeBy,
LoadingRefChangeTime=@LoadingRefChangeTime
where
RcvNo=@RcvNo


GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedChecking]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CargoReceivedChecking]
(
@RcvNo nvarchar(10),@InChecked bit , @InCheckedComment nvarchar(100), @InChechedTime datetime, @InCheckedBy nvarchaR(10)
)
AS
SET DATEFORMAT DMY;
UPDATE CargoReceived
SET
InChecked=@InChecked,
InCheckedComment=@InCheckedComment,
InChechedTime=@InChechedTime,
InCheckedBy=@InCheckedBy
where
RcvNo=@RcvNo


GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedConfirmArrival]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[CargoReceivedConfirmArrival]
(
@RcvNo nvarchar(10),@ConfirmArriveStatus nvarchar(10),@ArriveDate DateTime, @ConfirmArriveBy nvarchar(10)
)
AS
SET DATEFORMAT DMY
UPDATE CargoReceived 
SET 
ConfirmArriveStatus=@ConfirmArriveStatus,
ArriveDate=@ArriveDate,
ConfirmArriveTime=getdate(),
ConfirmArriveBy=@ConfirmArriveBy
Where RcvNo=@RcvNo
GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedDelete]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[CargoReceivedDelete]
(
@RcvNo as nvarchar(10)
)
as 
Delete from CargoReceived
where RcvNo=@RcvNo




GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedDirectMarkAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CargoReceivedDirectMarkAdd]
(
@RcvNo nvarchar(10), @DirectMark bit, @DirectMarkTime datetime, @DirectMarkBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE CargoReceived
SET
directmark=@DirectMark, 
DirectMarkTime=@DirectMarkTime, 
DirectMarkBy=@DirectMarkBy
where
RcvNo=@RcvNo 


GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedEditManual]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










CREATE        procedure [dbo].[CargoReceivedEditManual]
(
@RcvNo nvarchar(10), @RcvDate datetime, @RcvTime datetime, @ShipperCode nvarchar(5), @ContractNo nvarchar(50), @ItemNo nvarchar(50), @InvoiceNo nvarchar(50), @PONo nvarchar(50), @DeliveryNo decimal, @ShippingMode nvarchar(10), @CargoType nvarchar(10), @Ctns decimal , @Pcs decimal, @LorryNo nvarchar(50), @QCType nvarchar(10), @CBM money, @TradeLane nvarchar(10), @Country nvarchar(10),@ScanQty decimal,@IntakeComments nvarchar(200), @DateUpdate Datetime, @UpdateBy nvarchar(5),@InQty decimal, @NofBar money
)
AS
SET Dateformat DMY;
UPDATE
CargoReceived
SET

ShipperCode=@ShipperCode,
RcvDate=@RcvDate,
RcvTime=@RcvTime,
ContractNo=@ContractNo, 
ItemNo=@ItemNo , 
InvoiceNo=@InvoiceNo, 
PONo=@PONo , 
DeliveryNo=@DeliveryNo, 
ShippingMode=@ShippingMode, 
CargoType=@CargoType , 
Ctns=@Ctns , 
Pcs=@Pcs , 
LorryNo=@LorryNo, 
QCType=@QCType, 
CBM=@CBM,
CtnsIn=@Ctns , 
PcsIn=@Pcs ,
CBMIn=@CBM,
TradeLane=@TradeLane, 
Country=@Country,
ShippingModeIn=@ShippingMode,
DeliveryNoIn=@DeliveryNo,
TradelaneIn=@TradeLane, 
CountryIn=@Country,
DateUpdate=@DateUpdate,
UpdateBy=@UpdateBy,
InQty=@InQty,
NofBar=@NofBar
where
RcvNo=@RcvNo






GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedHoldToShipActionAddExcel]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CargoReceivedHoldToShipActionAddExcel]
(
@RcvNo nvarchar(10),@nApprvToShipAction nvarchar(50),@nApprvToShipActionBy nvarchar(10),@nApprvToShipActionTime datetime
)
AS
SET DATEFORMAT DMY;
UPDATE CargoReceived 
SET
nApprvToShipAction=@nApprvToShipAction,
nApprvToShipActionBy=@nApprvToShipActionBy,
nApprvToShipActionTime=@nApprvToShipActionTime
where
RcvNo=@RcvNo
GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedHoldToShipAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CargoReceivedHoldToShipAdd]
(
@RcvNo nvarchar(10),@nApprvToShip nvarchar(50),@nApprvToShipBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE CargoReceived 
SET
nApprvToShip=@nApprvToShip,
nApprvToShipBy=@nApprvToShipBy,
nApprvToShipTime=GetDate()
where
RcvNo=@RcvNo
GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedHoldToShipAddExcel]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CargoReceivedHoldToShipAddExcel]
(
@RcvNo nvarchar(10),@nApprvToShip nvarchar(50),@nApprvToShipBy nvarchar(10),@nApprvToShipTime datetime,@nApprvToShipAction nvarchar(100), @nApprvToShipActionTime datetime,@nApprvToShipActionBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE CargoReceived 
SET
nApprvToShip=@nApprvToShip,
nApprvToShipBy=@nApprvToShipBy,
nApprvToShipTime=@nApprvToShipTime,
nApprvToShipAction=@nApprvToShipAction,
nApprvToShipActionTime=@nApprvToShipActionTime,
nApprvToShipActionBy=@nApprvToShipActionBy
where
RcvNo=@RcvNo
GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedItemOptionLookupAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[CargoReceivedItemOptionLookupAdd]
(
@RcvNo nvarchar(10),@TotalPlatformPartner varchar(30)
)
AS
SET DATEFORMAT DMY
UPDATE CargoReceived 
SET
ItemOptionLookup='Update',
TotalPlatformPartner=@TotalPlatformPartner
where
RcvNo=@RcvNo
GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedJMBPklistAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CargoReceivedJMBPklistAdd]
(
@RcvNo nvarchar(10), @InboundETD datetime,@InboundVesselOrderNo decimal, @InboundContainerOrderNo decimal,@ShipperCode nvarchar(5),
@Ctns decimal,@PCS decimal, @CBM money,@GrossWgt money
)
AS
SET DATEFORMAT DMY;
UPDATE CargoReceived
set
InboundETD=@InboundETD,
InboundVesselOrderNo=@InboundVesselOrderNo,
InboundContainerOrderNo=@InboundContainerOrderNo,
ShipperCode=@ShipperCode,
Ctns=@Ctns,
PCS=@PCS,
CBM=@CBM,
GrossWgt=@GrossWgt
where
RcvNo=@RcvNo
GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedJMBTrackAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[CargoReceivedJMBTrackAdd]
(
@RcvNo nvarchar(10),@InboundBookingType nvarchar(10),@CargoFrom nvarchar(10),@InboundBookingDate datetime,@ShipperCode nvarchar(10),@ContractNo nvarchar(50),
@ItemNo nvarchar(50),@PONo nvarchar(50),@DeliveryNo decimal,@ShippingMode nvarchar(10),@CargoType nvarchar(10),@Ctns decimal,@PCS decimal,
@CBM money,@GrossWgt money,@TradeLane nvarchar(20),@Country nvarchar(20),@Warehouse nvarchar(50),@DropNo varchar(10)
)
as
SET DATEFORMAT DMY;
INSERT INTO CargoReceived
(RcvNo,InboundBookingType,CargoFrom,InboundBookingDate,ShipperCode,ContractNo,ItemNo,PONo,DeliveryNo,ShippingMode,CargoType,Ctns,PCS,CBM,GrossWgt,TradeLane,Country,Warehouse,WarehouseIn,ItemOptionLookup,DropNo)
values(@RcvNo,@InboundBookingType,@CargoFrom,@InboundBookingDate,@ShipperCode,@ContractNo,@ItemNo,@PONo,@DeliveryNo,@ShippingMode,@CargoType,@Ctns,@PCS,@CBM,@GrossWgt,@TradeLane,@Country,@Warehouse,@Warehouse,'Update',@DropNo)
GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedLastBoxIDAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[CargoReceivedLastBoxIDAdd]
(
@RcvNo nvarchar(10),@LastPackBoxNo decimal)
AS
Update CargoReceived
set
LastPackBoxNo=@LastPackBoxNo
where
rcvNo=@RcvNo
GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedLimaValidate]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[CargoReceivedLimaValidate]
(
@RcvNo nvarchar(10),@LimaValidate bit, @LimaValidateTime datetime, @Authorized bit,@AuthDate DateTime, @Warehouse nvarchar(50), @LimaShipDate datetime, @LimaPLDate datetime,@CBM money, @GrossWgt money, @Descrepancy nvarchar(500),@NextToPay money, @DescrepancyOK bit
)
AS
SET DATEFORMAT DMY;
UPDATE CargoReceived
SET 

LimaValidate=@LimaValidate,
LimaValidateTime=@LimaValidateTime,
Authorized=@Authorized,
AuthDate=@AuthDate,
Warehouse=@Warehouse,
LimaShipDate=@LimaShipDate,
LimaPLDate=@LimaPLDate,
CBM=@CBM,
GrossWgt=@GrossWgt,
Descrepancy=@Descrepancy,
NextToPay=@NextToPay,
DescrepancyOK=@DescrepancyOK

where
RcvNo=@RcvNo




GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedLoadApprvRequest]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CargoReceivedLoadApprvRequest]
(
@RcvNo nvarchar(10),@ApprvReqStatus nvarchar(10),@ApprvReqBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE CargoReceived
SET 
ApprvReqStatus=@ApprvReqStatus,
ApprvReqTime=GETDATE(),
ApprvReqBy=@ApprvReqBy
where 
RcvNo=@RcvNo
GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedLoadCancel]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CargoReceivedLoadCancel]
(
@RcvNo nvarchar(10), @LoadCancelStatus nvarchar(20),@LoadCancelDate datetime, @LoadCancelBy nvarchar(10), @RemoveStatus nvarchar(10), @RemoveStatusDoneDate datetime, @RemoveStatusDoneBy nvarchar(10),@RemoveQty decimal, @RemoveType nvarchar(10)
)
AS
SET DATEFORMAT DMY;
Update CargoReceived
SET

LoadCancelStatus=@LoadCancelStatus,
LoadCancelBy=@LoadCancelBy,
LoadCancelDate=@LoadCancelDate,
LoadCancelQty=RemoveQty,
RemoveStatus=@RemoveStatus,
RemoveStatusDoneDate=@RemoveStatusDoneDate,
RemoveStatusDoneBy=@RemoveStatusDoneBy,
RemoveQty=@RemoveQty,
RemoveType=@RemoveType

where
RcvNo=@RcvNo




GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedLoadPlan]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CargoReceivedLoadPlan]
(
@RcvNo nvarchar(10),@ContainerOrderNo decimal,@LoadPosition decimal, @LimaPosition decimal, @RemoveStatus nvarchar(10), @RemoveStatusDoneDate datetime, @RemoveStatusDoneBy nvarchar(10),@LoadingRef nvarchar(10)
)
as
SET DATEFORMAT DMY;
UPDATE CargoReceived
SET
ContainerOrderNo=@ContainerOrderNo,
LoadPosition=@LoadPosition,
LimaPosition=@LimaPosition,
RemoveStatus=@RemoveStatus,
RemoveStatusDoneDate=@RemoveStatusDoneDate,
RemoveStatusDoneBy=@RemoveStatusDoneBy,
loadingref=@LoadingRef
Where
RcvNo=@RcvNo



GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedLoadPlanSCMNoAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CargoReceivedLoadPlanSCMNoAdd]
(
@RcvNo nvarchar(10), @SCMNo nvarchar(20)
)
as
SET DATEFORMAT DMY;
UPDATE CargoReceived
SET
SCMNo=@SCMNo

Where
RcvNo=@RcvNo
GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedLockUnload]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure  [dbo].[CargoReceivedLockUnload]
(
@RcvNo nvarchar(10),@LockUnloadBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE CargoReceived 
SET
LockUnload=1,
LockUnloadBy=@LockUnloadBy,
LockUnloadTime=GETDATE()
where
RcvNo=@RcvNo
GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedManulRemoveRange]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[CargoReceivedManulRemoveRange]
(
@RcvNo nvarchar(10), @RemoveStatus nvarchar(10),@RemoveStatusDoneDate datetime, @RemoveStatusDoneBy nvarchar(10), @RemoveDoneDate datetime, @RemoveDoneBy nvarchar(10),@RemoveType nvarchar(10),@RemoveQty decimal,@RemoveReference nvarchar(20)
)
AS
SET DATEFORMAT DMY;
UPDATE CargoReceived
SET
RemoveStatus=@RemoveStatus,
RemoveStatusDoneDate=@RemoveStatusDoneDate,
RemoveStatusDoneBy=@RemoveStatusDoneBy,
RemoveDoneDate=@RemoveDoneDate,
RemoveDoneBy=@RemoveDoneBy,
RemoveType=@RemoveType,
RemoveQty=@RemoveQty,
RemoveReference=@RemoveReference
 where
 RcvNo=@RcvNo
 
 update CargoBarCode
 SET 
 status='Remove'
 where
 RcvNo=@RcvNo
 


GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedManulRemoveSea]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[CargoReceivedManulRemoveSea]
(
@RcvNo nvarchar(10),  @RemoveDoneDate datetime, @RemoveDoneBy nvarchar(10),@RemoveType nvarchar(10),@RemoveQty decimal
)
AS
SET DATEFORMAT DMY;
UPDATE CargoReceived
SET

RemoveDoneDate=@RemoveDoneDate,
RemoveDoneBy=@RemoveDoneBy,
RemoveType=@RemoveType,
RemoveQty=@RemoveQty
 where
 RcvNo=@RcvNo
 
 update CargoBarCode
 SET 
 status='Remove'
 where
 RcvNo=@RcvNo
 


GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedOkToLoadAir]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CargoReceivedOkToLoadAir]
(
@RcvNo nvarchar(10),@RemoveStatus nvarchar(10), @RemoveStatusDoneDate datetime, @RemoveStatusDoneBy nvarchar(10), @Descrepancy nvarchar(500)
)
as
SET DATEFORMAT DMY;
UPDATE CargoReceived
SET
RemoveStatus=@RemoveStatus,
RemoveStatusDoneDate=@RemoveStatusDoneDate,
RemoveStatusDoneBy=@RemoveStatusDoneBy,
Descrepancy=@Descrepancy
Where
RcvNo=@RcvNo



GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedOkToShipAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CargoReceivedOkToShipAdd]
(
@RcvNo nvarchar(10),@ApprvToShip nvarchar(50),@ApprvToShipBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE CargoReceived 
SET
Authorized=1,
AuthDate= CAST(GETDATE() As Date),
AuthTime=GETDATE(),
ApprvToShip=@ApprvToShip,
ApprvToShipBy=@ApprvToShipBy

where
RcvNo=@RcvNo
GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedOkToShipAddExcel]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CargoReceivedOkToShipAddExcel]
(
@RcvNo nvarchar(10),@ApprvToShip nvarchar(50),@ApprvToShipBy nvarchar(10),@AuthDate datetime
)
AS
SET DATEFORMAT DMY;
UPDATE CargoReceived 
SET
Authorized=1,
AuthDate= @AuthDate,
AuthTime=@AuthDate,
ApprvToShip=@ApprvToShip,
ApprvToShipBy=@ApprvToShipBy

where
RcvNo=@RcvNo
GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedOut]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CargoReceivedOut]
(
@RcvNo nvarchar(10), @OutTime datetime, @OutBy nvarchar(10)
)
as
SET DATEFORMAT DMY;
UPDATE CargoReceived
SET
OutTime=@OutTime,
OutBy=@OutBy
Where
RcvNo=@RcvNo



GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedOutManual]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CargoReceivedOutManual]
(
@RcvNo nvarchar(10), @OutTime datetime, @OutBy nvarchar(10),@RemoveQty decimal, @isManualOut bit, @LorryNoLoad nvarchar(50)
)
as
SET DATEFORMAT DMY;
UPDATE CargoReceived
SET
OutTime=@OutTime,
OutBy=@OutBy,
RemoveQty=@RemoveQty,
isManualOut=@isManualOut,
LorryNoLoad=@LorryNoLoad
Where
RcvNo=@RcvNo



GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedPackListUpdate]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CargoReceivedPackListUpdate]
(
@RcvNo nvarchar(10), @PackListUpdate bit, @PackListUpdateTime datetime, @PackListUpdateBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE CargoReceived
SET
PackListUpdate=@PackListUpdate, 
PackListUpdateTime=@PackListUpdateTime, 
PackListUpdateBy=@PackListUpdateBy
where
RcvNo=@RcvNo 


GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedPartialRemove]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





create     procedure [dbo].[CargoReceivedPartialRemove]
(
@RcvNo nvarchar(10),@CtnsSelect decimal, @PCSSelect decimal, @CBMSelect Decimal,@RemovePartDate datetime,@RemovePartBy nvarchar(10)
)
AS
SET Dateformat DMY;
Update
CargoReceived
SET
Ctns=(Ctns-@CtnsSelect),
ScanQty=(ScanQty-@CtnsSelect),
PCS=(PCS-@PCSSelect),
CBM=(CBM-@CBMSelect),
RemovePartQty=RemovePartQty+@CtnsSelect,
RemovePartPCS=RemovePartPCS+@PCSSelect,
RemovePartCBM=RemovePartCBM+@CBMSelect,
RemovePartDate=@RemovePartDate,
RemovePartBy=@RemovePartBy

where
RcvNo=@RcvNo 
--










GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedPickENADataStatusAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CargoReceivedPickENADataStatusAdd]
(
@RcvNo nvarchar(10),@PickENADataStatus nvarchar(10),@PickENADataBy nvarchar(10)
)
AS
SET DATEFORMAT DMY
UPDATE CargoReceived
SET
PickENADataStatus=@PickENADataStatus,
PickENADataBy=@PickENADataBy,
PickENADataTime=GETDATE()
WHere
RcvNo=@RcvNo

GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedPickPackCompleteAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[CargoReceivedPickPackCompleteAdd]
(
@RcvNo nvarchar(10),@PickPackStatus nvarchar(10),@PickPackStatusBy nvarchar(10),@ReWorkQty decimal,@InPCS decimal,@PickQtyAllowMismatch bit,@PackCBM money,@PackWgt money
)
AS
Set Dateformat dmy;
UPDATE CargoReceived
SET
ReWorkQty=ReWorkQty+1,
InPCS=InPCS+@InPCS,
PickPackStatusBy=@PickPackStatusBy,
PickPackStatusTime=GETDATE(),
PickQtyAllowMismatch= case  PickQtyAllowMismatch
when 0 then @PickQtyAllowMismatch else 1 end,



PickPackStatus= Case InQty
when ReWorkQty+1 then 'Finish'
else ''
end



where
RcvNo=@RcvNo
GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedPickPackDoneFirewall]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[CargoReceivedPickPackDoneFirewall]
(
    @RcvNo nvarchar(10),
    @PickPackStatusBy nvarchar(10),
    @ReWorkQty decimal
)
AS
BEGIN
    SET DATEFORMAT dmy;

    UPDATE CargoReceived
    SET
        FirewallQty = FirewallQty + @ReWorkQty,
        FirewallStatusBy = @PickPackStatusBy,
        FirewallStatusDoneTime = GETDATE(),
        FirewallStatus = CASE 
                            WHEN InQty = ReWorkQty THEN 'Finish' 
                            ELSE '' 
                         END
    WHERE
        RcvNo = @RcvNo;
END
GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedPickPackPCSAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[CargoReceivedPickPackPCSAdd]
(
@RcvNo nvarchar(10),@InPCS decimal,  @PackCBM money, 
    @PackWgt money
)
AS
Set Dateformat dmy;
UPDATE CargoReceived
SET
InPCS=InPCS+@InPCS,
SizeMismatchPCS=SizeMismatchPCS+@InPCS,
PackCBM = CASE PackCBM 
                    WHEN 0 THEN CBM + @PackCBM 
                    ELSE PackCBM + @PackCBM 
                 END,
        PackWgt = CASE PackWgt 
                    WHEN 0 THEN GrossWgt + @PackWgt 
                    ELSE PackWgt + @PackWgt 
                 END

where
RcvNo=@RcvNo

GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedPickPackStorePackDone]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[CargoReceivedPickPackStorePackDone]
(
@RcvNo nvarchar(10),@PickPackStatus nvarchar(10),@PickPackStatusBy nvarchar(10),@ReWorkQty decimal,@InPCS decimal,@PackCBM money,@PackWgt money
)
AS
Set Dateformat dmy;
UPDATE CargoReceived
SET
ReWorkQty=ReWorkQty+@ReworkQty,

InPCS=InPCS+@InPCS,

PickPackStatusBy=@PickPackStatusBy,
PickPackStatusTime=GETDATE(),
PackCbm=PackCBM+@PackCBM,
PackWgt=PackWgt+@PackWgt,


PickPackStatus= Case when InQty=ReWorkQty+@ReworkQty then 'Finish' else '' end



where
RcvNo=@RcvNo
GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedPickPackStorePackDoneFirewall]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[CargoReceivedPickPackStorePackDoneFirewall]
(
    @RcvNo nvarchar(10),
    @PickPackStatus nvarchar(10),
    @PickPackStatusBy nvarchar(10),
    @ReWorkQty decimal,
    @InPCS decimal,
    @PackCBM money,
    @PackWgt money
)
AS
BEGIN
    SET DATEFORMAT dmy;

    UPDATE CargoReceived
    SET
        FirewallQty = FirewallQty + @ReWorkQty,
        FirewallStatusBy = @PickPackStatusBy,
        FirewallStatusDoneTime = GETDATE(),
        FirewallStatus = CASE 
                            WHEN InQty = ReWorkQty + @ReWorkQty THEN 'Finish' 
                            ELSE '' 
                         END
    WHERE
        RcvNo = @RcvNo;
END
GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedPickPackTagMissingPCSAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CargoReceivedPickPackTagMissingPCSAdd]
(
    @RcvNo nvarchar(10),
    @InPCS decimal,
    @PackCBM money, 
    @PackWgt money
)
AS
BEGIN
    SET DATEFORMAT dmy;

    UPDATE CargoReceived
    SET
        InPCS = InPCS + @InPCS,
        TagMissingPCS = TagMissingPCS + @InPCS,
        PackCBM = CASE PackCBM 
                    WHEN 0 THEN CBM + @PackCBM 
                    ELSE PackCBM + @PackCBM 
                 END,
        PackWgt = CASE PackWgt 
                    WHEN 0 THEN GrossWgt + @PackWgt 
                    ELSE PackWgt + @PackWgt 
                 END
    WHERE
        RcvNo = @RcvNo;
END
GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedPickValidateCompleteAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[CargoReceivedPickValidateCompleteAdd]
(
@RcvNo nvarchar(10),@PCSValidationStatus nvarchar(10),@PCSValidationStatusBy nvarchar(10),@ValidateQty decimal,@PCSValidateCount decimal,@PickQtyAllowMismatch bit,@PackCBM money,@PackWgt money
)
AS
Set Dateformat dmy;
UPDATE CargoReceived
SET
ValidateQty=ValidateQty+1,
PCSValidateCount=PCSValidateCount+@PCSValidateCount,
PCSValidationStatusBy=@PCSValidationStatusBy,
PCSValidationStatusTime=GETDATE(),
PickQtyAllowMismatch= case  PickQtyAllowMismatch
when 0 then @PickQtyAllowMismatch else 1 end,



PCSValidationStatus= Case InQty
 when ValidateQty+1 then 'Finish'
 else ''
 end,

--PackCBM=case when StorePickStatus<>''  then 0 else case when PackCBM=0 then  CBM+@PackCBM else PackCBM+@PackCBM end end,
PackWgt=case PackWgt when 0 then GrossWgt+@PackWgt else PackWgt+@PackWgt end





where
RcvNo=@RcvNo
GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedPickValidateCompleteAdd1]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CargoReceivedPickValidateCompleteAdd1]
(
    @RcvNo NVARCHAR(10),
    @PCSValidationStatus NVARCHAR(10),
    @PCSValidationStatusBy NVARCHAR(10),
    @ValidateQty DECIMAL,
    @PCSValidateCount DECIMAL,
    @PickQtyAllowMismatch BIT,
    @PackCBM MONEY,
    @PackWgt MONEY,
	@NofParts DECIMAL,
	@NofSwingticket DECIMAL
)
AS
BEGIN
    SET DATEFORMAT DMY;

    UPDATE CargoReceived
    SET
        ValidateQty = ValidateQty + 1,
        PCSValidateCount = PCSValidateCount + @PCSValidateCount,
		nofParts= @NofParts,
		NofSwingticket = @NofSwingticket,
        PCSValidationStatusBy = @PCSValidationStatusBy,
        PCSValidationStatusTime = GETDATE(),
        PickQtyAllowMismatch = CASE PickQtyAllowMismatch
                                    WHEN 0 THEN @PickQtyAllowMismatch 
                                    ELSE 1 
                                END,
        PCSValidationStatus = CASE InQty
                                    WHEN ValidateQty + 1 THEN 'Finish'
                                    ELSE ''
                               END,
        --PackCBM = CASE 
        --              WHEN StorePickStatus <> '' THEN 0 
        --              ELSE CASE 
        --                       WHEN PackCBM = 0 THEN CBM + @PackCBM 
        --                       ELSE PackCBM + @PackCBM 
        --                   END 
        --          END,
        PackWgt = CASE PackWgt 
                      WHEN 0 THEN GrossWgt + @PackWgt 
                      ELSE PackWgt + @PackWgt 
                  END
    WHERE
        RcvNo = @RcvNo;
END
GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedPickValidationPCSAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[CargoReceivedPickValidationPCSAdd]
(
@RcvNo nvarchar(10),@InPCS decimal
)
AS
Set Dateformat dmy;
UPDATE CargoReceived
SET
PCSValidateCount=PCSValidateCount+@InPCS,
SizeMismatchPCS=SizeMismatchPCS+@InPCS

where
RcvNo=@RcvNo

GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedQCAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE    procedure
[dbo].[CargoReceivedQCAdd]
(
@RcvNo nvarchar(10) , @QCDone bit , @QCDoneDate Datetime, @QCResult nvarchar(10), @QCDoneBy nvarchar(5), @QCRemarks nvarchar(100), @QCShippingMode nvarchar(10),@QCStaffCode nvarchar(10),@AirCost nvarchar(10), @DeliveryNo decimal,@Ctns decimal, @PCS decimal, @CBM money,@TradeLane nvarchar(10),@Country nvarchar(10),@QCDoneTimeSystem datetime
)
As
SET DateFormat DMY;
UPDATE CargoReceived
SET
QCDone=@QCDone,
QCDoneDate=@QCDoneDate,
QCDoneBy=@QCDoneBy,
QCRemarks=@QCRemarks,
ShippingMode=@QCShippingMode,
QCResult=@QCResult,
QCStaffCode=@QCStaffCode,
AirCost=@AirCost,
DeliveryNo=@DeliveryNo,
Ctns=@Ctns,
PCS=@PCS,
CBM=@CBM,
TradeLane=@TradeLane,
Country=@Country,
QCDoneTimeSystem=@QCDoneTimeSystem
where
RcvNo=@RcvNo






GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedQCAddMockshop]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE    procedure
[dbo].[CargoReceivedQCAddMockshop]
(
@RcvNo nvarchar(10) , @QCDone bit , @QCDoneDate Datetime, @QCResult nvarchar(10), @QCDoneBy nvarchar(5), @QCRemarks nvarchar(100), @QCShippingMode nvarchar(10),@QCStaffCode nvarchar(10),@AirCost nvarchar(10), @DeliveryNo decimal,@Ctns decimal, @PCS decimal, @CBM money,@TradeLane nvarchar(10),@Country nvarchar(10),@QCDoneTimeSystem datetime, @ItemCategory nvarchar(20), @GrossWgt money
)
As
SET DateFormat DMY;
UPDATE CargoReceived
SET
QCDone=@QCDone,
QCDoneDate=@QCDoneDate,
QCDoneBy=@QCDoneBy,
QCRemarks=@QCRemarks,
ShippingMode=@QCShippingMode,
QCResult=@QCResult,
QCStaffCode=@QCStaffCode,
AirCost=@AirCost,
DeliveryNo=@DeliveryNo,
Ctns=@Ctns,
PCS=@PCS,
CBM=@CBM,
TradeLane=@TradeLane,
Country=@Country,
QCDoneTimeSystem=@QCDoneTimeSystem,
ItemCategory=@ItemCategory,
GrossWgt=@GrossWgt
where
RcvNo=@RcvNo






GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedQCIn]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CargoReceivedQCIn]
(
@RcvNo nvarchar(10), @QCCtns decimal 
)
AS 
SET DATEFORMAT DMY;
UPDATE CargoReceived
SET 
QCCtns=QCCtns +@QCCtns
where
RcvNo=@RcvNo



GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedQCInAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CargoReceivedQCInAdd]
(
@RcvNo nvarchar(10), @QCIn bit, @QCInTime datetime, @QCInBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE CargoReceived
SET
QCIn=@QCIn, 
QCInTime=@QCInTime, 
QCInBy=@QCInBy
where
RcvNo=@RcvNo 


GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedQCInCheckBackAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CargoReceivedQCInCheckBackAdd]
(
@RcvNo nvarchar(10), @QCInCheckBack bit, @QCInCheckBackTime datetime, @QCInCheckBackBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE CargoReceived
SET
QCInCheckBack=@QCInCheckBack, 
@QCInCheckBackTime=@QCInCheckBackTime, 
@QCInCheckBackBy=@QCInCheckBackBy
where
RcvNo=@RcvNo 


GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedRejecton]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CargoReceivedRejecton]
(
@RcvNo nvarchar(10),@RemoveStatus nvarchar(10), @RemoveStatusDoneDate datetime, @RemoveStatusDoneBy nvarchar(10), @RemovalComments nvarchar(200)
)
as
SET DATEFORMAT DMY;
UPDATE CargoReceived
SET
RemoveStatus=@RemoveStatus,
RemoveStatusDoneDate=@RemoveStatusDoneDate,
RemoveStatusDoneBy=@RemoveStatusDoneBy,
RemovalComments=@RemovalComments
Where
RcvNo=@RcvNo



GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedRemovalPlan]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[CargoReceivedRemovalPlan]
(
@RcvNo nvarchar(10), @LoadNo nvarchar(10),@RemoveStatus nvarchar(10), @RemoveStatusDoneDate datetime, @RemoveStatusDoneBy nvarchar(10)
)

AS
SET DATEFORMAT DMY;
Update CargoReceived
SET
LoadNo=@LoadNo,
RemoveStatus=@RemoveStatus,
RemoveStatusDoneDate=@RemoveStatusDoneDate,
RemoveStatusDoneBy=@RemoveStatusDoneBy
where
RcvNo=@RcvNo


GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedRemoveAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE      procedure [dbo].[CargoReceivedRemoveAdd]
(
@RcvNo nvarchar(10),@RemoveStatus nvarchar(10), @RemoveStatusDoneDate datetime, @RemoveStatusDoneBy nvarchar(10)
)
AS
SET Dateformat DMY;
Update
CargoReceived
SET
RemoveStatus=@RemoveStatus,
RemoveStatusDoneDate=@RemoveStatusDoneDate,
RemoveStatusDoneby=@RemoveStatusDoneby
where
RcvNo=@RcvNo








GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedScanQtyIn]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




create     procedure [dbo].[CargoReceivedScanQtyIn]
(
@RcvNo nvarchar(10)
)
AS
SET Dateformat DMY;
Update
CargoReceived
SET
ScanQty=ScanQty+1
where
RcvNo=@RcvNo







GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedScanQtyOut]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




create     procedure [dbo].[CargoReceivedScanQtyOut]
(
@RcvNo nvarchar(10)
)
AS
SET Dateformat DMY;
Update
CargoReceived
SET
RemoveQty=RemoveQty+1
where
RcvNo=@RcvNo







GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedShipmentChanges]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CargoReceivedShipmentChanges]
(
@RcvNo nvarchar(10),@DeliveryNo decimal, @ShippingMode nvarchar(10),@TradeLane nvarchar(20), @Country nvarchar(20),@DeliveryNoQC decimal, @ShippingModeQC nvarchar(10),@TradeLaneQC nvarchar(20), @CountryQC nvarchar(20),@RemoveStatus nvarchar(10)
)
AS
SET DATEFORMAT DMY;
Update CargoReceived
SET
DeliveryNo=@DeliveryNo,
ShippingMode=@ShippingMode,
TradeLane=@TradeLane,
Country=@Country,
ShippingModeQC=@ShippingModeQC,
DeliveryNoQC=@DeliveryNoQC,
TradeLaneQC=@TradeLaneQC,
CountryQC=@CountryQC,
RemoveStatus=@RemoveStatus
where
RcvNo=@RcvNo




GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedStorePickUpdate]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[CargoReceivedStorePickUpdate]
(
@RcvNo nvarchar(10),@StorePickStausBy nvarchar(10),@StorePickStatusTime datetime
)
AS
SET DateFORMAT DMY;
UPDATE Cargoreceived
SET 
StorePickStatus='Update',
packcbm=0,
StorePickStausBy=@StorePickStausBy,
StorePickStatusTime=@StorePickStatusTime
where
RcvNo=@RcvNo
GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedSubJobAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[CargoReceivedSubJobAdd]
(
@RcvNo nvarchar(10),@SubJobNo nvarchar(20), @SubJobNoEnterBy nvarchar(10),@SubJobNoEnterTime datetime
)

AS
SET DATEFORMAT DMY;
Update CargoReceived
SET
SubJobNo=@SubJobNo,
SubJobNoEnterBy=@SubJobNoEnterBy,
SubJobNoEnterTime=@SubJobNoEnterTime
where
RcvNo=@RcvNo


GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedValidatePCSAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[CargoReceivedValidatePCSAdd]
(
@RcvNo nvarchar(10),@InPCS decimal
)
AS
Set Dateformat dmy;
UPDATE CargoReceived
SET
PCSValidateCount=PCSValidateCount+@InPCS,
SizeMismatchPCS=SizeMismatchPCS+@InPCS

where
RcvNo=@RcvNo

GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedVerificationAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[CargoReceivedVerificationAdd]
(
@RcvNo nvarchar(10),@Verification bit, @VerificationDate datetime,@VerificationTime datetime
)

AS
SET DATEFORMAT DMY;
Update CargoReceived
SET
Verification=@Verification,
VerificationDate=@VerificationDate,
VerificationTime=@VerificationTime
where
RcvNo=@RcvNo


GO
/****** Object:  StoredProcedure [dbo].[CargoReceivedVesselPlanAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CargoReceivedVesselPlanAdd]
(
@RcvNo nvarchar(10),@VesselOrderNo decimal,@BookingDate datetime,@VesselPlanDate datetime
)
AS
SET Dateformat DMY;
Update
CargoReceived
SET
VesselOrderNo=@VesselOrderNo,
BookingDate=@BookingDate,
VesselPlanDate=@VesselPlanDate,
LimaValidate=0

where
RcvNo=@RcvNo



GO
/****** Object:  StoredProcedure [dbo].[CargoReturnAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CargoReturnAdd]
(
@RcvNo nvarchar(10), @RtnDate datetime
)
AS
SET dateformat dmy;
Insert Into
CargoReturn
(RcvNo, RtnDate)
Values(@RcvNo, @RtnDate)



GO
/****** Object:  StoredProcedure [dbo].[CargoStorePickInsertPCS]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[CargoStorePickInsertPCS]
(
@RcvNo nvarchar(10),@BoxId nvarchar(5),@BarcodeIn nvarchar(40),@NofPCS decimal,@UnloadTypeBoxIn nvarchar(10)
)
AS
Update CargoReceived
set inPCS =InPCS+ @NofPCS,
PackPCS=PackPCS+@NofPCS
where
RcvNo=@RcvNo

Update CargoBarcodeCtnOut
set
PackQty=PackQty+@NofPCS
where
RcvNo=@RcvNo and BoxId=@BoxId

if @UnloadTypeBoxIn like 'S%'
begin

update CargoBarCode
set
PickPcs=PickPcs+@NofPCS,
PackPCS=PackPCS+@NofPCS
where
rcvNo=@RcvNo and Barcode=@BarcodeIn
end
if @UnloadTypeBoxIn like 'M%'
begin

update CargoManualBox
set
PickPcs=PickPcs+@NofPCS,
PackPCS=PackPCS+@NofPCS
where
rcvNo=@RcvNo and Barcode=@BarcodeIn
end


GO
/****** Object:  StoredProcedure [dbo].[CargoStorePickPlanAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[CargoStorePickPlanAdd]
(
@RcvNo nvarchar(10), @ItemOption nvarchar(10), @StoreCode nvarchar(10), @PickPlanQty decimal, @PickedQty decimal, @DateEnter datetime
)
AS
SET DATEFORMAT DMY;
INSERT INTO CargoStorePickPlan
(RcvNo, ItemOption, StoreCode, PickPlanQty, PickedQty, DateEnter)
VALUES(@RcvNo, @ItemOption, @StoreCode, @PickPlanQty, @PickedQty, @DateEnter)
GO
/****** Object:  StoredProcedure [dbo].[CargoUploadAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE     procedure [dbo].[CargoUploadAdd]
(
@UpdNo nvarchar(10), @LoadRef nvarchar(10),@Loadby nvarchar(10)
)
AS
SET dateformat dmy;
Insert Into
CargoUpload
(UpdNo, UpdDate,UpdCtns,LoadRef,LoadBy)
Values(@UpdNo, getdate(),1,@LoadRef,@LoadBy)







GO
/****** Object:  StoredProcedure [dbo].[CargoUploadDtlAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create   procedure [dbo].[CargoUploadDtlAdd]
(
@RcvNo nvarchar(10),@ContainerOrderNo_  decimal
)
AS
SET Dateformat DMY;
Insert Into
CargoUploadDtl
(RcvNo , ContainerOrderNo_ )
Values
(@RcvNo , @ContainerOrderNo_)






GO
/****** Object:  StoredProcedure [dbo].[CargoUploadEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




create   procedure [dbo].[CargoUploadEdit]
(
@UpdNo nvarchar(10)
)
AS
SET dateformat dmy;
Update
CargoUpload
SET
UpdCtns=UpdCtns+1
where 
UpdNo=@UpdNo







GO
/****** Object:  StoredProcedure [dbo].[CargoUploadLorryNoAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




create    procedure [dbo].[CargoUploadLorryNoAdd]
(
@UpdNo nvarchar(10), @OrderNo decimal, @LorryNo nvarchar(50)
)
AS
SET dateformat dmy;
INSERT INTo
CargoUploadLorryNo
(UpdNo, OrderNo, LorryNo, LoadQty)
values(@UpdNo, @OrderNo, @LorryNo, 1)






GO
/****** Object:  StoredProcedure [dbo].[CargoUploadLorryNoEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




create   procedure [dbo].[CargoUploadLorryNoEdit]
(
@UpdNo nvarchar(10), @OrderNo decimal, @LorryNo nvarchar(50)
)
AS
SET dateformat dmy;
UPDATE
CargoUploadLorryNo
SET
LoadQty=LoadQty+1
where
UpdNo=@UpdNo and OrderNo=@OrderNo






GO
/****** Object:  StoredProcedure [dbo].[CargoUploadRcvNoAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create   procedure [dbo].[CargoUploadRcvNoAdd]
(
@UpdNo nvarchar(10), @OrderNo decimal, @RcvNo nvarchar(10)
)
AS
SET dateformat dmy;
INSERT INTO
CargoUploadRcvNo
(UpdNo, RcvNo, OrderNo, LoadQty)
Values
(@UpdNo, @RcvNo, @OrderNo, 1)






GO
/****** Object:  StoredProcedure [dbo].[CargoUploadRcvNoEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



create   procedure [dbo].[CargoUploadRcvNoEdit]
(
@UpdNo nvarchar(10), @OrderNo decimal, @RcvNo nvarchar(10)
)
AS
SET dateformat dmy;
UPDATE
CargoUploadRcvNo
SET
LoadQty=LoadQty+1
where
UpdNo=@UpdNo and RcvNo=@RcvNo and OrderNo=@OrderNo






GO
/****** Object:  StoredProcedure [dbo].[CFSUserRightsDelete]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE         proc [dbo].[CFSUserRightsDelete]
(
@UserId nvarchar(4)
)
as
delete UserRights
where UserId=@UserId
return












GO
/****** Object:  StoredProcedure [dbo].[CloudMenuAllocationAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CloudMenuAllocationAdd]
(
@UserId nvarchar(10), @MenuId nvarchar(20)
)
AS
SET DATEFORMAT DMY;
INSERT INTO CloudMenuAllocation
(UserId, MenuID)
values(@UserId, @MenuID)
GO
/****** Object:  StoredProcedure [dbo].[CloudMenuAllocationDelete]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CloudMenuAllocationDelete]
(
@UserId nvarchar(10)
)
AS
Delete from  CloudMenuAllocation
where UserId=@UserId


GO
/****** Object:  StoredProcedure [dbo].[CommentSave]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CommentSave]
		@RcvNo NVARCHAR(50),
    @Message NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE CargoReceived
    SET Comment=@Message
    WHERE RcvNo = @RcvNo
END
GO
/****** Object:  StoredProcedure [dbo].[ContainerDataAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  Procedure [dbo].[ContainerDataAdd]
(
@BookingDate datetime, @VesselOrderNo decimal, @ContainerOrderNo decimal, @ContainerNo nvarchar(20), @ContainerType nvarchar(10),@NextContainerNo nvarchar(50),  @CreateBy nvarchar(10), @VGM money
)
AS
SET DATEFORMAT DMY;
INSERT INTO  ContainerData
(BookingDate, VesselOrderNo, ContainerOrderNo, ContainerNo, ContainerType,NextContainerNo, DateCreate, CreateBy,VGM)
VALUES
(@BookingDate, @VesselOrderNo, @ContainerOrderNo, @ContainerNo, @ContainerType,@NextContainerNo,GETDATE(), @CreateBy,@VGM)





GO
/****** Object:  StoredProcedure [dbo].[ContainerDataEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[ContainerDataEdit]
(
@BookingDate datetime, @VesselOrderNo decimal, @ContainerOrderNo decimal, @ContainerNo nvarchar(20), @ContainerType nvarchar(10),@nEXTContainerNo nvarchar(50), @UpdateBy nvarchar(10),@VGM MONEY
)
AS
SET DATEFORMAT DMY;
UPDATE ContainerData
SET
ContainerNo=@ContainerNo,
ContainerType=@ContainerType,
DateUpdate=getdate(),
UpdateBy=@UpdateBy,
NextContainerNo=@NextContainerNo,
VGM=@VGM
WHERE
BookingDate=@BookingDate and VesselOrderNo=@VesselOrderNo and ContainerOrderNo=@ContainerOrderNo





GO
/****** Object:  StoredProcedure [dbo].[ContainerDataImportAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  Procedure [dbo].[ContainerDataImportAdd]
(
@BookingDate datetime, @VesselOrderNo decimal, @ContainerOrderNo decimal, @ContainerNo nvarchar(20), @ContainerType nvarchar(10), @CreateBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;
INSERT INTO  ContainerDataImport
(BookingDate, VesselOrderNo, ContainerOrderNo, ContainerNo, ContainerType, DateCreate, CreateBy,NextContainerNo)
VALUES
(@BookingDate, @VesselOrderNo, @ContainerOrderNo, @ContainerNo, @ContainerType, GETDATE(), @CreateBy, @ContainerNo)






GO
/****** Object:  StoredProcedure [dbo].[ContainerDataImportDOReleaseAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  Procedure [dbo].[ContainerDataImportDOReleaseAdd]
(
@BookingDate datetime, @VesselOrderNo decimal, @ContainerOrderNo decimal, @DOReleaseStatus nvarchar(20),  @DOReleaseStatusTime datetime, @DOReleaseStatusBy nvarchar(10),@HBNo nvarchar(50)
)
AS
SET DATEFORMAT DMY;
UPDATE ContainerDataImport
SET
DOReleaseStatus=@DOReleaseStatus,
DOReleaseStatusBy=@DOReleaseStatusBy,
DOReleaseStatusTime=@DOReleaseStatusTime,
HBNo=@HBNo
WHERE
BookingDate=@BookingDate and VesselOrderNo=@VesselOrderNo and ContainerOrderNo=@ContainerOrderNo






GO
/****** Object:  StoredProcedure [dbo].[ContainerDataImportEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[ContainerDataImportEdit]
(
@BookingDate datetime, @VesselOrderNo decimal, @ContainerOrderNo decimal, @ContainerNo nvarchar(20), @ContainerType nvarchar(10), @DateUpdate datetime, @UpdateBy nvarchar(10),@NextContainerNo nvarchar(50)
)
AS
SET DATEFORMAT DMY;
UPDATE ContainerDataImport
SET
ContainerNo=@ContainerNo,
ContainerType=@ContainerType,
DateUpdate=GETDATE(),
UpdateBy=@UpdateBy,
NextContainerNo=@NextContainerNo
WHERE
BookingDate=@BookingDate and VesselOrderNo=@VesselOrderNo and ContainerOrderNo=@ContainerOrderNo






GO
/****** Object:  StoredProcedure [dbo].[ContainerDataNoAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   Procedure [dbo].[ContainerDataNoAdd]
(
@BookingDate datetime, @VesselOrderNo decimal, @ContainerOrderNo decimal, @ContainerNo nvarchar(20), @ContainerType nvarchar(10), @CntrNoDate datetime, @CntrNoBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE ContainerData
SET
ContainerNo=@ContainerNo,
CntrNoDate=@CntrNoDate,
CntrNoBy=@CntrNoBy
WHERE
BookingDate=@BookingDate and VesselOrderNo=@VesselOrderNo and ContainerOrderNo=@ContainerOrderNo






GO
/****** Object:  StoredProcedure [dbo].[ContainerDataOutAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   Procedure [dbo].[ContainerDataOutAdd]
(
@BookingDate datetime, @VesselOrderNo decimal, @ContainerOrderNo decimal,@CntrOutDate datetime, @CntrOutBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE ContainerData
SET
CntrOut=1,
CntrOutDate=@CntrOutDate,
CntrOutBy=@CntrOutBy
WHERE
BookingDate=@BookingDate and VesselOrderNo=@VesselOrderNo and ContainerOrderNo=@ContainerOrderNo

Update VesselRegistry
set
CntrGateOut=1
where

BookingDate=@BookingDate and VesselOrderNo=@VesselOrderNo
GO
/****** Object:  StoredProcedure [dbo].[ContainerDataSCMLabelAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   Procedure [dbo].[ContainerDataSCMLabelAdd]
(
@BookingDate datetime, @VesselOrderNo decimal, @ContainerOrderNo decimal, @SCMLabelNo nvarchar(20)
)
AS
SET DATEFORMAT DMY;
UPDATE ContainerData
SET
SCMLabelNo=@SCMLabelNo,
SCMLabelNoTime=GETDATE()

WHERE
BookingDate=@BookingDate and VesselOrderNo=@VesselOrderNo and ContainerOrderNo=@ContainerOrderNo
GO
/****** Object:  StoredProcedure [dbo].[ContainerDataSealAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   Procedure [dbo].[ContainerDataSealAdd]
(
@BookingDate datetime, @VesselOrderNo decimal, @ContainerOrderNo decimal, @SealNo nvarchar(25), @SealBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE ContainerData
SET
SealNo=@SealNo,
SealDate=GETDATE(),
SealBy=@SealBy
WHERE
BookingDate=@BookingDate and VesselOrderNo=@VesselOrderNo and ContainerOrderNo=@ContainerOrderNo






GO
/****** Object:  StoredProcedure [dbo].[ContractForcastAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ContractForcastAdd]
(
@ContractNo nvarchar(50),@Mode nvarchar(10), @DeliveryNo decimal, @Units decimal, @ExFactoryDate datetime, @Departure nvarchar(50),@TradeLane nvarchar(20), @CargoType nvarchar(50),@NextDirect nvarchar(10), @Warehouse nvarchar(50), @ItemNo nvarchar(50), @EnterBy nvarchar(10)
)
AS 
SET DATEFORMAT DMY;
INSERT INTO ContractForcast
(ContractNo,Mode, DeliveryNo, Units, ExFactoryDate, Departure,TradeLane, CargoType,NextDirect, Warehouse, ItemNo,EnterTime, EnterBy)
values
(@ContractNo,@Mode, @DeliveryNo, @Units, @ExFactoryDate, @Departure,@TradeLane, @CargoType,@NextDirect, @Warehouse, @ItemNo,GETDATE(),@EnterBy)


GO
/****** Object:  StoredProcedure [dbo].[ContractForcastAddFull]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[ContractForcastAddFull]
(
@ContractNo nvarchar(50),@Mode nvarchar(10), @DeliveryNo decimal, @Units decimal, @ExFactoryDate datetime, @Departure nvarchar(50),@TradeLane nvarchar(20), @CargoType nvarchar(50),@NextDirect nvarchar(10), @Warehouse nvarchar(50), @ItemNo nvarchar(50), @EnterBy nvarchar(10),@EnterDate datetime,@ShipperCode nvarchar(10)
)
AS 
SET DATEFORMAT DMY;
INSERT INTO ContractForcast
(ContractNo,Mode, DeliveryNo, Units, ExFactoryDate, Departure,TradeLane, CargoType,NextDirect, Warehouse, ItemNo,EnterTime, EnterBy,ShipperCode,ExLocalOfficeDate)
values
(@ContractNo,@Mode, @DeliveryNo, @Units, @ExFactoryDate, @Departure,@TradeLane, @CargoType,@NextDirect, @Warehouse, @ItemNo,@EnterDate,@EnterBy,@ShipperCode,@ExFactoryDate)


GO
/****** Object:  StoredProcedure [dbo].[ContractForcastEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ContractForcastEdit]
(
@ContractNo nvarchar(50),@Mode nvarchar(10), @DeliveryNo decimal, @Units decimal, @ExFactoryDate datetime, @Departure nvarchar(50),@TradeLane nvarchar(20), @CargoType nvarchar(50),@NextDirect nvarchar(10), @Warehouse nvarchar(50), @ItemNo nvarchar(50), @UpdateBy nvarchar(10)
)
AS 
SET DATEFORMAT DMY;
update ContractForcast
Set
Mode=@Mode,
DeliveryNo=@DeliveryNo,
Units=@Units,
ExFactoryDate=@ExFactoryDate,
Departure=@Departure,
TradeLane=@TradeLane,
CargoType=@CargoType,
NextDirect=@NextDirect,
ExLocalOfficeDate=@ExFactoryDate,
Warehouse=@Warehouse,
ItemNo=@ItemNo,
UpdateDate=getdate(),
UpdateBy=@UpdateBy
where
ContractNo=@ContractNo




GO
/****** Object:  StoredProcedure [dbo].[ContractListJMBAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ContractListJMBAdd]
(
@ContractNo nvarchar(50)
)
AS
SET DATEFORMAT DMY;
INSERT INTO ContractListJMB
(ContractNo)
values(@ContractNo)
GO
/****** Object:  StoredProcedure [dbo].[CountryAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CountryAdd]
(
@CountryCode nvarchar(10), @CountryName nvarchar(50), @CargoMovement nvarchar(10), @EnterBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;
INSERT INTO Country
(CountryCode, CountryName, CargoMovement, DateEnter, EnterBy)
values(@CountryCode, @CountryName, @CargoMovement, Getdate(), @EnterBy)
GO
/****** Object:  StoredProcedure [dbo].[CountryEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CountryEdit]
(
@CountryCode nvarchar(10), @CountryName nvarchar(50), @CargoMovement nvarchar(10), @UpdateBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE Country
SET
CountryName=@CountryName,
CargoMovement=@CargoMovement,
DateUpdate=getdate(),
UpdateBy=@UpdateBy
where
Countrycode=@CountryCode

GO
/****** Object:  StoredProcedure [dbo].[CtnPMUpdateRemoveOldPmUsageRecords]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CtnPMUpdateRemoveOldPmUsageRecords]
    @FirstBookingNo NVARCHAR(50),
    @FirstBarcodeNo NVARCHAR(50),
	@EntryPoint VARCHAR(50)
AS
BEGIN
    -- Delete records from CargoBarcodePMUsage table
    DELETE FROM CargoBarcodePMUsage
    WHERE RcvNo = @FirstBookingNo AND Barcode = @FirstBarcodeNo and EntryPoint = @EntryPoint; 

END;
GO
/****** Object:  StoredProcedure [dbo].[CtnSwapCargoBarcodeAndSwingTicketDataUpdate]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CtnSwapCargoBarcodeAndSwingTicketDataUpdate]
    @FirstBookingNo NVARCHAR(50),
    @FirstBarcodeNo NVARCHAR(50),
    @SecondBookingNo NVARCHAR(50),
    @SecondBarcodeNo NVARCHAR(50),
    @FirstBookingNoCode NVARCHAR(50),
    @SecondBookingNoCode NVARCHAR(50)
AS
BEGIN
    -- Update CargoBarCode table
    UPDATE CargoBarCode
    SET RcvNo = @FirstBookingNoCode
    WHERE RcvNo = @FirstBookingNo AND BarCode = @FirstBarcodeNo;

    UPDATE CargoBarCode
    SET RcvNo = @SecondBookingNoCode
    WHERE RcvNo = @SecondBookingNo AND BarCode = @SecondBarcodeNo;

    UPDATE CargoBarCode
    SET RcvNo = @SecondBookingNo
    WHERE RcvNo = @FirstBookingNoCode;

    UPDATE CargoBarCode
    SET RcvNo = @FirstBookingNo
    WHERE RcvNo = @SecondBookingNoCode;

    -- Update PickSwingTicketData table
    UPDATE PickSwingTicketData
    SET RcvNo = @FirstBookingNoCode
    WHERE RcvNo = @FirstBookingNo AND BarCode = @FirstBarcodeNo;

    UPDATE PickSwingTicketData
    SET RcvNo = @SecondBookingNoCode
    WHERE RcvNo = @SecondBookingNo AND BarCode = @SecondBarcodeNo;

    UPDATE PickSwingTicketData
    SET RcvNo = @SecondBookingNo
    WHERE RcvNo = @FirstBookingNoCode;

    UPDATE PickSwingTicketData
    SET RcvNo = @FirstBookingNo
    WHERE RcvNo = @SecondBookingNoCode;

    -- Delete records from CargoBarcodePMUsage table
    DELETE FROM CargoBarcodePMUsage
    WHERE RcvNo = @FirstBookingNo AND Barcode = @FirstBarcodeNo;

    DELETE FROM CargoBarcodePMUsage
    WHERE RcvNo = @SecondBookingNo AND Barcode = @SecondBarcodeNo;
END;
GO
/****** Object:  StoredProcedure [dbo].[DestWarehouseAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure
[dbo].[DestWarehouseAdd]
(
@WhCode nvarchar(10), @WhDes nvarchar(50),@CountryCode nvarchar(10)
)
AS
SET DATEFORMAT DMY;
INSERT INTO 
DestWarehouse
(WhCode, WhDes,CountryCode)
Values
(@WhCode, @WhDes,@CountryCode)



GO
/****** Object:  StoredProcedure [dbo].[DestWarehouseEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure
[dbo].[DestWarehouseEdit]
(
@WhCode nvarchar(10), @WhDes nvarchar(50),@CountryCode nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE
DestWarehouse
SET

CountryCode=@CountryCode
where WhDes=@WhDes



GO
/****** Object:  StoredProcedure [dbo].[ExpMWBAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE     procedure [dbo].[ExpMWBAdd]
(
@JobNo nvarchar(10), @ETD datetime, @ETA datetime, @Vessel nvarchar(50), @CreateBy nvarchar(5), @CreateDate datetime, @LastContainerOrderNo decimal
)
as 
SET DATEFORMAT DMY;
INSERT INTO ExpMWB
(JobNo, ETD, ETA, Vessel, CreateBy, CreateDate, LastContainerOrderNo)
VALUES(@JobNo, @ETD, @ETA, @Vessel, @CreateBy, @CreateDate, @LastContainerOrderNo)









GO
/****** Object:  StoredProcedure [dbo].[ExpMWBCancel]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create  Procedure [dbo].[ExpMWBCancel]
(
@JobNo nvarchar(10), @isCancel bit, @CancelBy nvarchar(5), @CancelDate datetime
)
as
SET DATEFORMAT DMY;
UPDATE ExpMWB SET
isCancel=@isCancel,
CancelDate=@CancelDate,
CancelBy=@CancelBy
Where JobNo=@JobNo





GO
/****** Object:  StoredProcedure [dbo].[ExpMWBCntrLoadPlanAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[ExpMWBCntrLoadPlanAdd]
(
@JobNo nvarchar(10), @ContainerOrderNo decimal, @OrderNo decimal, @RcvNo nvarchar(10), @isActive bit, @LoadPosition decimal
)
As
Set dateformat DMY;
Insert Into
ExpMWBCntrLoadPlan
(JobNo, ContainerOrderNo, OrderNo, RcvNo, isActive,LoadPosition)
Values(@JobNo, @ContainerOrderNo, @OrderNo, @RcvNo, @isActive, @LoadPosition)




GO
/****** Object:  StoredProcedure [dbo].[ExpMWBCntrLoadPlanEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[ExpMWBCntrLoadPlanEdit]
(
@JobNo nvarchar(10), @ContainerOrderNo decimal, @OrderNo decimal, @RcvNo nvarchar(10), @isActive bit, @LoadPosition decimal
)
As
Set dateformat DMY;
Update
ExpMWBCntrLoadPlan
Set
RcvNo=@RcvNo,
isActive=@isActive,
LoadPosition=@LoadPosition
where
JobNo=@JobNo and ContainerOrderNo=@ContainerOrderNo and OrderNo=@OrderNo




GO
/****** Object:  StoredProcedure [dbo].[ExpMWBCntrLoadPlanInActive]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[ExpMWBCntrLoadPlanInActive]
(
@JobNo nvarchar(10), @ContainerOrderNo decimal
)
As
Set dateformat DMY;
Update
ExpMWBCntrLoadPlan
Set
RcvNo='',
isActive=0
where
JobNo=@JobNo and ContainerOrderNo=@ContainerOrderNo 



GO
/****** Object:  StoredProcedure [dbo].[ExpMWBConfirm]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create  Procedure [dbo].[ExpMWBConfirm]
(
@JobNo nvarchar(10), @isConfirm bit, @ConfirmBy nvarchar(5), @ConfirmDate datetime
)
as
SET DATEFORMAT DMY;
UPDATE ExpMWB SET
isConfirm=@isConfirm,
ConfirmDate=@ConfirmDate,
ConfirmBy=@ConfirmBy
Where JobNo=@JobNo





GO
/****** Object:  StoredProcedure [dbo].[ExpMWBContainerDataAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE       procedure [dbo].[ExpMWBContainerDataAdd]
(
@JobNo nvarchar(10), @OrderNo Decimal, @ContainerNo nvarchar(20), @ContainerType nvarchar(5),  @SealNo nvarchar(30), @NextContainerNo nvarchar(20)
)
as
SET DATEFORMAT DMY;
INSERT INTO ExpMWBContainerData
(JobNo, OrderNo, ContainerNo, ContainerType, SealNo, NextContainerNo)
values(@JobNo, @OrderNo, @ContainerNo, @ContainerType, @SealNo, @NextContainerNo)









GO
/****** Object:  StoredProcedure [dbo].[ExpMWBContainerDataDelete]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create  procedure [dbo].[ExpMWBContainerDataDelete]
(
@JobNo nvarchar(10)
)
as
SET DATEFORMAT DMY;
delete ExpMWBContainerData Where JobNo=@JobNo




GO
/****** Object:  StoredProcedure [dbo].[ExpMWBContainerDataEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE      procedure [dbo].[ExpMWBContainerDataEdit]
(
@JobNo nvarchar(10), @OrderNo Decimal, @ContainerNo nvarchar(20), @ContainerType nvarchar(5), @SealNo nvarchar(30), @NextContainerNo nvarchar(10)
)
as
SET DATEFORMAT DMY;
UPDATE
ExpMWBContainerData
SET
ContainerNo=@ContainerNo, 
ContainerType=@ContainerType, 
SealNo=@SealNo,
NextContainerNo=@NextContainerNo
where
JobNo=@JobNo and OrderNo=@OrderNo






GO
/****** Object:  StoredProcedure [dbo].[ExpMWBEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE   procedure [dbo].[ExpMWBEdit]
(
@JobNo nvarchar(10), @ETD datetime, @ETA datetime,@Vessel varchar(50), @UpdateBy nvarchar(5), @UpdateDate datetime, @LastContainerOrderNo decimal
)
as 
SET DATEFORMAT DMY;
UPDATE ExpMWB SET
JobNo=@JobNo, 
ETD=@ETD, 
ETA=@ETA, 
Vessel=@Vessel, 
UpdateBy=@UpdateBy, 
UpdateDate=@UpdateDate, 
LastContainerOrderNo=@LastContainerOrderNo
Where JobNo=@JobNo







GO
/****** Object:  StoredProcedure [dbo].[ExpMWBJobNoLastAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create   procedure [dbo].[ExpMWBJobNoLastAdd]
(
@JobYear numeric, @LastJobNo numeric
)
as
SET DATEFORMAT DMY;
Insert INTO  ExpMWBJobNoLast
(JobYear,LastJobNo)
Values(@jobYear,@LastJobNo)







GO
/****** Object:  StoredProcedure [dbo].[ExpMWBJobNoLastEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   procedure [dbo].[ExpMWBJobNoLastEdit]
(
@JobYear numeric, @LastJobNo numeric
)
as
SET DATEFORMAT DMY;
UPDATE ExpMWBJobNoLast
SET
JobYear=@jobYear, 
LastJobNo=@LastJobNo
where JobYear=@JobYear





GO
/****** Object:  StoredProcedure [dbo].[ExpVesselRegistryAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE     procedure [dbo].[ExpVesselRegistryAdd]
(
@ETD datetime, @RegistryNo decimal, @Vessel nvarchar(50), @VoyageNo varchar(20), @MotherVessel nvarchar(50), @MotherVoyageNo nvarchar(20), @CutoffTime datetime, @OnBoard datetime, @DateCreate datetime, @CreateBy nvarchar(5)
)
as
SET DATEFORMAT DMY;
INSERT INTO ExpVesselRegistry
(ETD, RegistryNo, Vessel, VoyageNo, MotherVessel, MotherVoyageNo, CutoffTime, OnBoard, DateCreate, CreateBy)
values(@ETD, @RegistryNo, @Vessel, @VoyageNo, @MotherVessel, @MotherVoyageNo, @CutoffTime, @OnBoard, @DateCreate, @CreateBy)








GO
/****** Object:  StoredProcedure [dbo].[ExpVesselRegistryEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE     procedure [dbo].[ExpVesselRegistryEdit]
(
@ETD datetime, @RegistryNo decimal, @Vessel nvarchar(50), @VoyageNo varchar(20), @MotherVessel nvarchar(50), @MotherVoyageNo nvarchar(20), @CutoffTime datetime, @OnBoard datetime, @DateUpdate datetime, @UpdateBy nvarchar(5)
)
as
SET DATEFORMAT DMY;
UPDATE ExpVesselRegistry SET

ETD=@ETD, 
RegistryNo=@RegistryNo, 
Vessel=@Vessel, 
VoyageNo=@VoyageNo, 
MotherVessel=@MotherVessel, 
MotherVoyageNo=@MotherVoyageNo, 
CutoffTime=@CutoffTime, 
OnBoard=@OnBoard, 
DateUpdate=@DateUpdate, 
UpdateBy=@UpdateBy

Where RegistryNo=@RegistryNo and ETD=@ETD









GO
/****** Object:  StoredProcedure [dbo].[gargoRecivedValidatePcsUpdate]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[gargoRecivedValidatePcsUpdate]
    @FirstBookingNo NVARCHAR(50),
    @FirstValidatePcs INT,
    @SecondBookingNo NVARCHAR(50),
    @SecondValidatePcs INT
AS
BEGIN
    -- Update the PCSValidateCount for the first booking number
    UPDATE CargoReceived
    SET PCSValidateCount = @FirstValidatePcs
    WHERE RcvNo = @FirstBookingNo;

    -- Update the PCSValidateCount for the second booking number
    UPDATE CargoReceived
    SET PCSValidateCount = @SecondValidatePcs
    WHERE RcvNo = @SecondBookingNo;
END;
GO
/****** Object:  StoredProcedure [dbo].[GrnAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GrnAdd]
(
@GrnNo nvarchar(10), @GrnDate datetime, @GrnTime datetime, @RefNo nvarchar(50), @CusdecNo nvarchar(50), @LorryNo nvarchar(50), @DriverName varchar(50), @DriverContactNo nvarchar(50), @Remarks nvarchar(100), @GateIn datetime
)
AS
SET DATEFORMAT DMY;
INSERT INTO Grn
(GrnNo, GrnDate, GrnTime, RefNo, CusdecNo, LorryNo, DriverName, DriverContactNo, Remarks, GateIn)
values
(@GrnNo, @GrnDate, @GrnTime, @RefNo, @CusdecNo, @LorryNo, @DriverName, @DriverContactNo, @Remarks, @GateIn)
GO
/****** Object:  StoredProcedure [dbo].[HistoryCargoBarCodeUpdate]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[HistoryCargoBarCodeUpdate]
(
@Barcode nvarchar(40), @RcvNo nvarchar(10), @Location nvarchar(10), @Status nvarchar(10), @QCYes bit, @QCInTime datetime, @VerificationYes bit, @VerificationInTime datetime, @RtnNo nvarchar(10), @UpNo nvarchar(10), @BarCodePcs decimal, @BarCodeGrsWgt money, @BarCodeNetWgt money, @UpLoadCntrNo nvarchar(20)
)
AS
INSERT INTO 
HistoryCargoBarCode
(Barcode, RcvNo, Location, Status, QCYes, QCInTime, VerificationYes, VerificationInTime, RtnNo, UpNo, BarCodePcs, BarCodeGrsWgt, BarCodeNetWgt, UpLoadCntrNo)
values
(@Barcode, @RcvNo, @Location, @Status, @QCYes, @QCInTime, @VerificationYes, @VerificationInTime, @RtnNo, @UpNo, @BarCodePcs, @BarCodeGrsWgt, @BarCodeNetWgt, @UpLoadCntrNo)


GO
/****** Object:  StoredProcedure [dbo].[HistoryCargoReceivedUpdate]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[HistoryCargoReceivedUpdate]
(
@RcvNo nvarchar(10), @EntryType nvarchar(10), @RcvDate datetime, @RcvTime datetime, @ShipperCode nvarchar(5), @ContractNo nvarchar(50), @ItemNo nvarchar(50), 
@InvoiceNo nvarchar(50), @PONo nvarchar(50), @DeliveryNo decimal, @ShippingMode nvarchar(10), 
@CargoType nvarchar(10), @Ctns decimal, @PCS decimal, @ScanQty decimal, @CBM money, @GrossWgt money, 
@LorryNo nvarchar(50), @IntakeComments nvarchar(200), @WHLocation nvarchar(5), @TradeLane nvarchar(20), 
@Country nvarchar(20), @Warehouse nvarchar(50), @QCType nvarchar(10), @EnterBy nvarchar(10), @EnterDate datetime, 
@QCStatus nvarchar(10), @QCDone bit, @QCDoneDate datetime, @QCResult nvarchar(10), @QCDoneBy nvarchar(10), @QCRemarks nvarchar(200), @QCDoneTimeSystem datetime, 
@LimaValidate bit, @LimaValidateTime datetime, @Authorized bit, @AuthDate datetime, @AuthTime datetime, @DC nvarchar(20) , @LimaShipDate datetime, @LimaPLDate datetime, @AirCost nvarchar(10), @NextToPay money, @Verification bit, @VerificationDate datetime, @VerificationTime datetime, @VerificationBy nvarchar(10), 
@RemoveStatus nvarchar(10), @RemoveStatusDoneDate datetime, @RemoveStatusDoneBy nvarchar(10), @RemoveDoneDate datetime, @RemoveDoneBy nvarchar(10), @RemoveType nvarchar(10), @RemovalComments nvarchar(200), @InQty decimal, @RemoveQty decimal, @DeleteDate datetime, @QCStaffCode nvarchar(10), @BookingDate datetime, @LoadNo nvarchar(10), @VesselOrderNo decimal, @VesselPlanDate datetime, @ContainerOrderNo decimal, @LoadPosition decimal, @LimaPosition decimal, @LoadingRef nvarchar(10), @ShippingModeIn nvarchar(10), 
@PCSIn decimal, @CtnsIn decimal, @CBMIn money, @DeliveryNoIn decimal, @TradeLaneIn nvarchar(20), @CountryIn nvarchar(20), 
@QCDate datetime, @RemovePartQty decimal, @RemovePartPCS decimal, @RemovePartCBM money, @RemoveQtyPartScan decimal, @RemovePartDate datetime, @RemovePartBy nvarchar(10), @RemovePartQtyRemark nvarchar(100), 
@DateUpdate datetime, @UpdateBy nvarchar(10), @SplitRcvNo nvarchar(10), @LoadType nvarchar(10), @LorryNoLoad nvarchar(50), @OutTime datetime, @OutBy nvarchar(10), 
@OldShippingMode nvarchar(10), @OldAirCost nvarchar(10), @ModeChangeDate datetime, @ModeChangeBy nvarchar(10), @ShippingModeQC nvarchar(10), @DeliveryNoQC decimal, @TradeLaneQC nvarchar(20), @CountryQC nvarchar(20), @QCCtns decimal, @QCPcs decimal, @QCPcsReject decimal, @Descrepancy nvarchar(500), @DescrepancyTime datetime, 
@DescrepancyBy nvarchar(10), @QCQty decimal, @VerifyQty decimal, @InChecked bit, @InCheckedComment nvarchar(100), @InChechedTime datetime, @InCheckedBy nvarchar(10), @UpLiftStatus nvarchar(10), @UpLiftTime datetime, @UpLiftBy nvarchar(10), 
@UnLoadStart datetime, @UnLoadEnd datetime, @LoadStart datetime, @LoadEnd datetime
)
as
INSERT INTO HistoryCargoReceived
(RcvNo, EntryType, RcvDate, RcvTime, ShipperCode, ContractNo, ItemNo, InvoiceNo, PONo, DeliveryNo, ShippingMode, CargoType, Ctns, PCS, ScanQty, CBM, GrossWgt, LorryNo, IntakeComments, WHLocation, TradeLane, Country, Warehouse, QCType, EnterBy, EnterDate, QCStatus, QCDone, QCDoneDate, QCResult, QCDoneBy, QCRemarks, QCDoneTimeSystem, LimaValidate, LimaValidateTime, Authorized, AuthDate, AuthTime, DC, LimaShipDate, LimaPLDate, AirCost, NextToPay, Verification, VerificationDate, VerificationTime, VerificationBy, RemoveStatus, RemoveStatusDoneDate, RemoveStatusDoneBy, RemoveDoneDate, RemoveDoneBy, RemoveType, RemovalComments, InQty, RemoveQty, DeleteDate, QCStaffCode, BookingDate, LoadNo, VesselOrderNo, VesselPlanDate, ContainerOrderNo, LoadPosition, LimaPosition, LoadingRef, ShippingModeIn, PCSIn, CtnsIn, CBMIn, DeliveryNoIn, TradeLaneIn, CountryIn, QCDate, RemovePartQty, RemovePartPCS, RemovePartCBM, RemoveQtyPartScan, RemovePartDate, RemovePartBy, RemovePartQtyRemark, DateUpdate, UpdateBy, SplitRcvNo, LoadType, LorryNoLoad, OutTime, OutBy, OldShippingMode, OldAirCost, ModeChangeDate, ModeChangeBy, ShippingModeQC, DeliveryNoQC, TradeLaneQC, CountryQC, QCCtns, QCPcs, QCPcsReject, Descrepancy, DescrepancyTime, DescrepancyBy, QCQty, VerifyQty, InChecked, InCheckedComment, InChechedTime, InCheckedBy, UpLiftStatus, UpLiftTime, UpLiftBy, UnLoadStart, UnLoadEnd, LoadStart, LoadEnd)
values
(@RcvNo, @EntryType, @RcvDate, @RcvTime, @ShipperCode, @ContractNo, @ItemNo, @InvoiceNo, @PONo, @DeliveryNo, @ShippingMode, @CargoType, @Ctns, @PCS, @ScanQty, @CBM, @GrossWgt, @LorryNo, @IntakeComments, @WHLocation, @TradeLane, @Country, @Warehouse, @QCType, @EnterBy, @EnterDate, @QCStatus, @QCDone, @QCDoneDate, @QCResult, @QCDoneBy, @QCRemarks, @QCDoneTimeSystem, @LimaValidate, @LimaValidateTime, @Authorized, @AuthDate, @AuthTime, @DC, @LimaShipDate, @LimaPLDate, @AirCost, @NextToPay, @Verification, @VerificationDate, @VerificationTime, @VerificationBy, @RemoveStatus, @RemoveStatusDoneDate, @RemoveStatusDoneBy, @RemoveDoneDate, @RemoveDoneBy, @RemoveType, @RemovalComments, @InQty, @RemoveQty, @DeleteDate, @QCStaffCode, @BookingDate, @LoadNo, @VesselOrderNo, @VesselPlanDate, @ContainerOrderNo, @LoadPosition, @LimaPosition, @LoadingRef, @ShippingModeIn, @PCSIn, @CtnsIn, @CBMIn, @DeliveryNoIn, @TradeLaneIn, @CountryIn, @QCDate, @RemovePartQty, @RemovePartPCS, @RemovePartCBM, @RemoveQtyPartScan, @RemovePartDate, @RemovePartBy, @RemovePartQtyRemark, @DateUpdate, @UpdateBy, @SplitRcvNo, @LoadType, @LorryNoLoad, @OutTime, @OutBy, @OldShippingMode, @OldAirCost, @ModeChangeDate, @ModeChangeBy, @ShippingModeQC, @DeliveryNoQC, @TradeLaneQC, @CountryQC, @QCCtns, @QCPcs, @QCPcsReject, @Descrepancy, @DescrepancyTime, @DescrepancyBy, @QCQty, @VerifyQty, @InChecked, @InCheckedComment, @InChechedTime, @InCheckedBy, @UpLiftStatus, @UpLiftTime, @UpLiftBy, @UnLoadStart, @UnLoadEnd, @LoadStart, @LoadEnd)


GO
/****** Object:  StoredProcedure [dbo].[InsertBarcodeSplitDelivery]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertBarcodeSplitDelivery]
    @SplitDeliveryId varchar(20),
    @BookingDate datetime,
    @VesselOrderNo decimal(18,0),
    @VesselName varchar(50),
    @VoyageNo varchar(20),
    @Carrier varchar(50),
    @ETD datetime,
    @ETA datetime,
    @OnBoard datetime,
    @CutOff datetime,
    @PortCode varchar(10),
    @ContainerOrderNo decimal(18,0),
    @ContainerNo varchar(20),
    @ContainerType varchar(10),
    @NextContainerNo varchar(50),
    @SCMNo varchar(20),
    @VGM money,
    @SealNo varchar(25),
    @GateOut datetime,
    @ShipMode varchar(10),
    @ExportType varchar(20)

AS
BEGIN
    INSERT INTO [dbo].[BarcodeSplitDelivery]
           ([SplitDeliveryId]
           ,[BookingDate]
           ,[VesselOrderNo]
           ,[VesselName]
           ,[VoyageNo]
           ,[Carrier]
           ,[ETD]
           ,[ETA]
           ,[OnBoard]
           ,[CutOff]
		   ,[ShipMode]
           ,[ContainerOrderNo]
           ,[ContainerNo]
           ,[ContainerType]
           ,[NextContainerNo]
           ,[SCMNo]
           ,[VGM]
           ,[SealNo]
           ,[GateOut]
		   ,[ExportType])
     VALUES
           (@SplitDeliveryId
           ,@BookingDate
           ,@VesselOrderNo
           ,@VesselName
           ,@VoyageNo
           ,@Carrier
           ,@ETD
           ,@ETA
           ,@OnBoard
           ,@CutOff
           ,@ShipMode
           ,@ContainerOrderNo
           ,@ContainerNo
           ,@ContainerType
           ,@NextContainerNo
           ,@SCMNo
           ,@VGM
           ,@SealNo
           ,@GateOut
		   ,@ExportType)
END
GO
/****** Object:  StoredProcedure [dbo].[InsertBarcodeSplitDeliveryLastId]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertBarcodeSplitDeliveryLastId]
    @SplitDeliveryNo DECIMAL(18, 2),
    @SplitDeliveryYear DECIMAL(18, 2)
AS
BEGIN
    INSERT INTO BarcodeSplitDeliveryLastId (SplitDeliveryNo, SplitDeliveryYear)
    VALUES (@SplitDeliveryNo, @SplitDeliveryYear);
END;
GO
/****** Object:  StoredProcedure [dbo].[InsertCargoBarcodeFirewallError]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertCargoBarcodeFirewallError]
    @RcvNo NVARCHAR(10),
    @BoxScanManual CHAR(1),
    @Barcode NVARCHAR(40),
    @ErrorType CHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO CargoBarcodeFirewallErrors (RcvNo, BoxScanManual, Barcode, ErrorType)
    VALUES (@RcvNo, @BoxScanManual, @Barcode, @ErrorType);
END;
GO
/****** Object:  StoredProcedure [dbo].[InsertContractsChainCodes]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertContractsChainCodes]
    @ChainCode CHAR(1),
    @ChainName VARCHAR(50),
    @TPPartnerName VARCHAR(20),
    @Range VARCHAR(20),
    @RangeBoxEAN VARCHAR(10)
AS
BEGIN
    INSERT INTO ContractsChainCodes (ChainCode, ChainName, TPPartnerName, Range, RangeBoxEAN)
    VALUES (@ChainCode, @ChainName, @TPPartnerName, @Range, @RangeBoxEAN);
END;
GO
/****** Object:  StoredProcedure [dbo].[InsertIntoPMIn]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertIntoPMIn]
(
    @InNo NVARCHAR(10),
    @PMIndate DATE,
    @Remarks NVARCHAR(MAX),
	@IsCancelled BIT, -- New parameter
    @UserID NVARCHAR(50), -- Assuming you pass a single value for UserID
	@PMSupplierCode NVARCHAR(5)
)
AS
BEGIN
        DECLARE @EnterBy NVARCHAR(50)
        DECLARE @UpdateBy NVARCHAR(50)
        DECLARE @EnterDate DATETIME
        DECLARE @UpdateDate DATETIME

        -- Check if the record exists in PMIn
        IF EXISTS (SELECT 1 FROM PMIn WHERE InNo = @InNo)
        BEGIN
            -- Record exists, set UpdateBy and do not change EnterBy
            SELECT @EnterBy = EnterBy, @EnterDate = EnterDate FROM PMIn WHERE InNo = @InNo
            SET @UpdateBy = @UserID
            SET @UpdateDate = GETDATE()
        END
        ELSE
        BEGIN
            -- Record does not exist, set EnterBy and UpdateBy as UserID
            SET @EnterBy = @UserID
            SET @EnterDate = GETDATE()
            SET @UpdateBy = @UserID
            SET @UpdateDate = GETDATE()
        END

        INSERT INTO PMIn (InNo, PMIndate, Remarks, IsCancelled, EnterBy, EnterDate, UpdateBy, UpdateDate, PMSupplierCode)
        VALUES (@InNo, @PMIndate, @Remarks, @IsCancelled, @EnterBy, @EnterDate, @UpdateBy, @UpdateDate, @PMSupplierCode)
    
        -- Error occurred, handle it here (you can log the error, throw it, etc.)
        -- For now, we'll just print the error message
        PRINT 'An error occurred: ' + ERROR_MESSAGE()
   
END
GO
/****** Object:  StoredProcedure [dbo].[InsertIntoPMInCancel]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertIntoPMInCancel]
(
    @InNo NVARCHAR(10),
    @IsCancelled BIT,
    @UserID NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	 DECLARE @UpdateDate DATETIME;
SET @UpdateDate = GETDATE();
    -- Update the specified record in PMIn table
    UPDATE PMIn
    SET IsCancelled = @IsCancelled,
        UpdateBy =  @UserID,
        UpdateDate = @UpdateDate
    WHERE InNo = @InNo;
END
GO
/****** Object:  StoredProcedure [dbo].[InsertIntoPMInDtl]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertIntoPMInDtl]
(
    @InNo NVARCHAR(10),
    @PMCode NVARCHAR(10),
    @PMQty MONEY,
    @CBM MONEY
)
AS
BEGIN
    INSERT INTO PMInDtl (InNo, PMCode, PMQty,CBM)
    VALUES (@InNo, @PMCode, @PMQty, @CBM)
END
	
GO
/****** Object:  StoredProcedure [dbo].[InsertIntoPMStockIssue]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Changed ALTER to CREATE to establish the new procedure
CREATE PROCEDURE [dbo].[InsertIntoPMStockIssue]
(
    @DateTime DATETIME,
    @PMCode NVARCHAR(10),
    @CBM MONEY
)
AS
BEGIN
    -- Setting NOCOUNT ON is a best practice to prevent extra result sets
    SET NOCOUNT ON;

    INSERT INTO PMStockIssue (DateAndTime, PMCode, CBM)
    VALUES (@DateTime, @PMCode, @CBM)
END
GO
/****** Object:  StoredProcedure [dbo].[InsertIntoPMWastage]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertIntoPMWastage]
(
    @InNo NVARCHAR(10),
    @PMIndate DATE,
    @Remarks NVARCHAR(MAX),
    @IsCancelled BIT,
    @UserID NVARCHAR(50)
)
AS
BEGIN
    DECLARE @EnterBy NVARCHAR(50)
    DECLARE @UpdateBy NVARCHAR(50)
    DECLARE @EnterDate DATETIME
    DECLARE @UpdateDate DATETIME

    -- Check if the record exists in PMIn
    IF EXISTS (SELECT 1 FROM PMWastage WHERE PMWastageNo = @InNo)
    BEGIN
        -- Record exists, set UpdateBy and do not change EnterBy
        SELECT @EnterBy = EnterBy, @EnterDate = EnterDate FROM PMWastage WHERE PMWastageNo = @InNo
        SET @UpdateBy = @UserID
        SET @UpdateDate = GETDATE()
    END
    ELSE
    BEGIN
        -- Record does not exist, set EnterBy and UpdateBy as UserID
        SET @EnterBy = @UserID
        SET @EnterDate = GETDATE()
        SET @UpdateBy = @UserID
        SET @UpdateDate = GETDATE()
    END

    INSERT INTO PMWastage (PMWastageNo, PMWastagedate, Remarks, IsCancelled, EnterBy, EnterDate, UpdateBy, UpdateDate)
    VALUES (@InNo, @PMIndate, @Remarks, @IsCancelled, @EnterBy, @EnterDate, @UpdateBy, @UpdateDate)

    -- Optional: Error handling (can be expanded if needed)
    PRINT 'Insert completed successfully.'
END
GO
/****** Object:  StoredProcedure [dbo].[InsertIntoPMWastageDtl]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertIntoPMWastageDtl]
(
    @InNo NVARCHAR(10),
    @PMCode NVARCHAR(10),
    @PMQty MONEY
)
AS
BEGIN
    INSERT INTO PMWastageDtl (PMWastageNo, PMCode, PMQty)
    VALUES (@InNo, @PMCode, @PMQty)
END
GO
/****** Object:  StoredProcedure [dbo].[InsertIntoWastedPMInCancel]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertIntoWastedPMInCancel]
(
    @PMWastageNo NVARCHAR(10),
    @IsCancelled BIT,
    @UserID NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UpdateDate DATETIME;
    SET @UpdateDate = GETDATE();

    -- Update the specified record in PMIn table
    UPDATE PMWastage
    SET 
        IsCancelled = @IsCancelled,
        UpdateBy = @UserID,
        UpdateDate = @UpdateDate
    WHERE 
        PMWastageNo = @PMWastageNo;
END
GO
/****** Object:  StoredProcedure [dbo].[ItemOptionMapAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ItemOptionMapAdd]
(
@ItemOption nvarchar(10),@OthItemId nvarchar(20)
)
AS
SET DATEFORMAT DMY;
INSERT INTO ItemOptionMap
(ItemOption, OthItemId)
values(@ItemOption, @OthItemId)
GO
/****** Object:  StoredProcedure [dbo].[LastGRNNoAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[LastGRNNoAdd]
(
@BookingYear decimal, @Lno decimal
)
AS
INSERT INTO LastGRNNo
(BookingYear,Lno)
values(@BookingYear,@Lno)
GO
/****** Object:  StoredProcedure [dbo].[LastGRNNoEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[LastGRNNoEdit]
(
@BookingYear decimal, @Lno decimal
)
AS
UPDATE LastGRNNo
SET 
Lno=@Lno
where BookingYear=@BookingYear
GO
/****** Object:  StoredProcedure [dbo].[LastLoadNoAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE   Procedure [dbo].[LastLoadNoAdd]
(
@Lno decimal
)
AS
SET DATEFORMAT DMY;
Update LastLoadNo
 set
Lno=@Lno
where
active=1







GO
/****** Object:  StoredProcedure [dbo].[LastRcvNoAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[LastRcvNoAdd]
(
@Lno decimal
)
AS
SET DATEFORMAT DMY;
Update LastRcvNo
 set
Lno=@Lno
where
active=1





GO
/****** Object:  StoredProcedure [dbo].[LastRcvNoBookingAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[LastRcvNoBookingAdd]
(
@BookingYear decimal, @Lno decimal
)
AS
INSERT INTO LastRcvNo
(BookingYear,Lno)
values(@BookingYear,@Lno)
GO
/****** Object:  StoredProcedure [dbo].[LastRcvNoBookingEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[LastRcvNoBookingEdit]
(
@BookingYear decimal, @Lno decimal
)
AS
UPDATE LastRcvNo
SET 
Lno=@Lno
where BookingYear=@BookingYear
GO
/****** Object:  StoredProcedure [dbo].[LoginByUsernamePassword]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoginByUsernamePassword]   
@username varchar(50),   
@password varchar(50)   
AS   
BEGIN   
SELECT UserId, username, password   
FROM PwInfo  
WHERE username = @username   
AND password = @password   END   



GO
/****** Object:  StoredProcedure [dbo].[LookupReset]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LookupReset]
    @ContractNo NVARCHAR(50),
    @DeliveryNo NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- Update CargoReceived table
    UPDATE cr
    SET ItemOptionLookup = ''
    FROM CargoReceived cr
    WHERE cr.ContractNo = @ContractNo
    AND cr.DeliveryNo = @DeliveryNo;

    -- Get RcvNo data
    DECLARE @RcvNo NVARCHAR(50);
    SELECT @RcvNo = RcvNo
    FROM CargoReceived
    WHERE ContractNo = @ContractNo
    AND DeliveryNo = @DeliveryNo;

    -- Delete matching rows from CargoItemOption table
    DELETE FROM CargoItemOption
    WHERE RcvNo = @RcvNo;

    -- Optional: Return the number of rows affected
    -- SELECT @@ROWCOUNT AS 'RowsAffected';
END;
GO
/****** Object:  StoredProcedure [dbo].[NofPartSave]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[NofPartSave]
	@RcvNo NVARCHAR(50),
	@nofParts int,
	@nofJokers int
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE CargoReceived
	SET nofParts= @nofParts
	WHERE RcvNo = @RcvNo

	
	UPDATE CargoBarCode
	SET NofParts= @nofParts,
	NofJokers = @nofJokers
	WHERE RcvNo = @RcvNo and ValidatePCS !=0 and PackPCS = 0
END
GO
/****** Object:  StoredProcedure [dbo].[OkToLoadReasonAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[OkToLoadReasonAdd]
(
@Reason nvarchar(50), @ReasonOrder decimal, @DtlReson nvarchar(1000), @Warehouse nvarchar(50)
)
AS
SET DATEFORMAT DMY;
INSERT INTO OkToLoadReason
(Reason, ReasonOrder, DtlReson, Warehouse)
values(@Reason, @ReasonOrder, @DtlReson, @Warehouse)
GO
/****** Object:  StoredProcedure [dbo].[PackJobNoAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[PackJobNoAdd]
(
@JobYear decimal, @LastJobNo decimal
)
AS
SET DATEFORMAT DMY;
INSERT INTO PackJobNo
(JobYear, LastJobNo)
values
(@JobYear, @LastJobNo)


GO
/****** Object:  StoredProcedure [dbo].[PackJobNoEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[PackJobNoEdit]
(
@JobYear decimal, @LastJobNo decimal
)
AS
SET DATEFORMAT DMY;
Update PackJobNo
SET
LastJobNo=@LastJobNo
where
JobYear=@JobYear


GO
/****** Object:  StoredProcedure [dbo].[PackPoPlanAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[PackPoPlanAdd]
(
@JobNo nvarchar(10), @ShipperCode nvarchar(10), @ContractNo nvarchar(50), @DeliveryNo decimal, @ItemNo nvarchar(10), @Ctns decimal, @PlanTime datetime, @PlanBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;
INSERT INTO PackPoPlan
(JobNo, ShipperCode, ContractNo, DeliveryNo, ItemNo, Ctns, PlanTime, PlanBy)
Values
(@JobNo, @ShipperCode, @ContractNo, @DeliveryNo, @ItemNo, @Ctns, @PlanTime, @PlanBy)


GO
/****** Object:  StoredProcedure [dbo].[PackPoPlanAddPCCR]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[PackPoPlanAddPCCR]
(
@JobNo nvarchar(10), @ShipperCode nvarchar(10), @ContractNo nvarchar(50), @DeliveryNo decimal, @ItemNo nvarchar(10), @Ctns decimal, @PlanTime datetime, @PlanBy nvarchar(10),
@ProductGroup nvarchar(100),@Supplier nvarchar(100),@Contact nvarchar(100),@BookingRef nvarchar(20),@ItemDes nvarchar(100),@ShippingMode nvarchar(10),@TypeRef nvarchar(10)

)
AS
SET DATEFORMAT DMY;
INSERT INTO PackPoPlan
(JobNo, ShipperCode, ContractNo, DeliveryNo, ItemNo, Ctns, PlanTime, PlanBy,ProductGroup,Supplier,Contact,BookingRef,ItemDes,ShippingMode,TypeRef)
Values
(@JobNo, @ShipperCode, @ContractNo, @DeliveryNo, @ItemNo, @Ctns, @PlanTime, @PlanBy,@ProductGroup,@Supplier,@Contact,@BookingRef,@ItemDes,@ShippingMode,@TypeRef)


GO
/****** Object:  StoredProcedure [dbo].[PackPoPlanBoxFilling]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[PackPoPlanBoxFilling]
(
@JobNo nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE
PackPoPlan
SET

CtnsComplete=CtnsComplete+1

Where
JobNo=@JobNo


GO
/****** Object:  StoredProcedure [dbo].[PackPoPlanComplete]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[PackPoPlanComplete]
(
@JobNo nvarchar(10),@ScanCompStatus nvarchar(10),@ScanCompBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE PackPoPlan
SET

ScanCompStatus=@ScanCompStatus,
ScanCompBy=@ScanCompBy,
ScanCompTime=GETDATE()
where
JobNo=@JobNo

GO
/****** Object:  StoredProcedure [dbo].[PackPOPlanCtnAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[PackPOPlanCtnAdd]
(
@jobNo nvarchar(10), @CtnOrderNo decimal, @CtnBarCode nvarchar(40),@CtnType nvarchar(10),@CtnLength money,@CtnWidth money, @CtnHeight money,@PackQty decimal,@EnterBy nvarchar(10),@OptionSize nvarchar(10),@CtnID nvarchar(10)
)
AS
SET DATEFORMAT DMY;
INSERT INTO PackPOPlanCtn
(JobNo, CtnOrderNo, CtnBarCode, CtnType, CtnLength, CtnWidth, CtnHeight,PackQty,EnterTime,EnterBy,OptionSize,CtnID)
values(@JobNo, @CtnOrderNo, @CtnBarCode, @CtnType, @CtnLength, @CtnWidth, @CtnHeight,@PackQty,GETDATE(),@EnterBy,@OptionSize,@CtnID)


GO
/****** Object:  StoredProcedure [dbo].[PackPOPlanCtnBoxFilling]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[PackPOPlanCtnBoxFilling]
(
@jobNo nvarchar(10), @CtnOrderNo decimal, @PackQty decimal,@CompleteStatus nvarchar(10),@CompleteBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE  PackPOPlanCtn
SET
PackQty=@PackQty,
CompleteStatus=@CompleteStatus,
CompleteTime=getdate(),
CompleteBy=@CompleteBy
where
JobNo=@jobNo and CtnOrderNo=@CtnOrderNo



GO
/****** Object:  StoredProcedure [dbo].[PackPOPlanCtnBoxTypeChange]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[PackPOPlanCtnBoxTypeChange](
@JobNo nvarchar(10),@CtnOrderNo decimal,@CtnType nvarchar(10),@CtnLength money,@CtnWidth money,@CtnHeight money
)
AS
SET DATEFORMAT DMY;
Update PackPOPlanCtn SET
CtnType=@CtnType,
CtnLength=@CtnLength,
CtnWidth=@CtnWidth,
CtnHeight=@CtnHeight
where
JobNo=@JobNo and CtnOrderNo=@CtnOrderNo

GO
/****** Object:  StoredProcedure [dbo].[PackPOPlanCtnSizeAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[PackPOPlanCtnSizeAdd]
(
@JobNo nvarchar(10),@CtnOrderNo decimal,@SizeBarcode nvarchar(40)
)
AS
SET DATEFORMAT DMY;
INSERT INTO PackPOPlanCtnSize
(JobNo, CtnOrderNo, SizeBarcode)
values(@JobNo, @CtnOrderNo, @SizeBarcode)




GO
/****** Object:  StoredProcedure [dbo].[PackPOPlanCtnSizeWrongAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[PackPOPlanCtnSizeWrongAdd]
(
@JobNo nvarchar(10), @CtnOrderNo decimal, @SizeBarcode nvarchar(40),@ErrorType nvarchar(100),@CtnBarCode nvarchar(40),@SizeCorrect nvarchar(20),@ValWrong nvarchar(20)
)
AS
SET DATEFORMAT DMY;

INSERT INTO PackPOPlanCtnSizeWrong
(JobNo, CtnOrderNo, SizeBarcode,ErrorType,CtnBarCode,PickDate,SizeCorrect,ValWrong)
values(@JobNo, @CtnOrderNo, @SizeBarcode, @ErrorType,@CtnBarCode,Getdate(),@SizeCorrect,@ValWrong)


GO
/****** Object:  StoredProcedure [dbo].[PackPOPlanCtnSizeWrongUnlock]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[PackPOPlanCtnSizeWrongUnlock]
(
@JobNo nvarchar(10), @CtnOrderNo decimal,  @UnlockedBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;

Update  PackPOPlanCtnSizeWrong
SET 
UnlockedBy=@UnlockedBy,
UnlockedTime=getdate()
Where JobNo=@JobNo and CtnOrderNo=@CtnOrderNo 



GO
/****** Object:  StoredProcedure [dbo].[PackPoPlanEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[PackPoPlanEdit]
(
@JobNo nvarchar(10), @ShipperCode nvarchar(10), @ContractNo nvarchar(50), @DeliveryNo decimal, @ItemNo nvarchar(10), @Ctns decimal, @PlanTime datetime, @PlanBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;
Update PackPoPlan
SET
ShipperCode=@ShipperCode, ContractNo=@ContractNo, DeliveryNo=@DeliveryNo, ItemNo=@ItemNo, Ctns=@Ctns, PlanTime=@PlanTime, PlanBy=@PlanBy
where
JobNo=@JobNo




GO
/****** Object:  StoredProcedure [dbo].[PackPoPlanEditPCCR]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[PackPoPlanEditPCCR]
(
@JobNo nvarchar(10), @ShipperCode nvarchar(10), @ContractNo nvarchar(50), @DeliveryNo decimal, @ItemNo nvarchar(10), @Ctns decimal, @PlanTime datetime, @PlanBy nvarchar(10),
@ProductGroup nvarchar(100),@Supplier nvarchar(100),@Contact nvarchar(100),@BookingRef nvarchar(20),@ItemDes nvarchar(100),@ShippingMode nvarchar(10),@TypeRef nvarchar(10)
)
AS
SET DATEFORMAT DMY;
Update PackPoPlan
SET
ShipperCode=@ShipperCode, ContractNo=@ContractNo, DeliveryNo=@DeliveryNo, ItemNo=@ItemNo, Ctns=@Ctns, PlanTime=@PlanTime, PlanBy=@PlanBy,
ProductGroup=@ProductGroup,
Supplier=@Supplier,
Contact=@Contact,
BookingRef=@BookingRef,
ItemDes=@ItemDes,
ShippingMode=@ShippingMode,
TypeRef=@TypeRef

where
JobNo=@JobNo




GO
/****** Object:  StoredProcedure [dbo].[PackPoPlanLastWrongUpdate]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[PackPoPlanLastWrongUpdate]
(
@JobNo nvarchar(10),@LastWrongNo decimal
)
AS
Set Dateformat DMY;
UPDATE PackPoPlan
SET LastWrongNo=@LastWrongNo


GO
/****** Object:  StoredProcedure [dbo].[PackPoPlanScanUpdate]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[PackPoPlanScanUpdate]
(
@JobNo nvarchar(10),@CtnsPack decimal,@LastCtnOrderNo decimal,@CtnsComplete decimal
)
AS
SET DATEFORMAT DMY;
UPDATE
PackPoPlan
SET
CtnsPack=@CtnsPack,
LastCtnOrderNo=@LastCtnOrderNo,
CtnsComplete=CtnsComplete+@CtnsComplete

Where
JobNo=@JobNo




GO
/****** Object:  StoredProcedure [dbo].[PackPoPlanSizeAddPCCR]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[PackPoPlanSizeAddPCCR](
@JobNo nvarchar(10), @OptionSize nvarchar(10), @OptionSizeDes nvarchar(50),@PlanQty decimal
)
AS
SET DATEFORMAT DMY
INSERT INTO PackPoPlanSize
(JobNo, OptionSize, OptionSizeDes, PlanQty)
values (@JobNo, @OptionSize, @OptionSizeDes,@PlanQty)
GO
/****** Object:  StoredProcedure [dbo].[PalletRacksAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[PalletRacksAdd]
(@RackNo nvarchar(10), @NofRows decimal, @NofLayers decimal, @NofPositions decimal)
AS
INSERT INTO PalletRacks
(RackNo, NofRows, NofLayers, NofPositions)
values(@RackNo, @NofRows, @NofLayers, @NofPositions)
GO
/****** Object:  StoredProcedure [dbo].[PalletRacksUtilizationAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[PalletRacksUtilizationAdd]
(@RackNo nvarchar(10), @PositionNo nvarchar(10))

AS
SET DATEFORMAT DMY;
INSERT INTO PalletRacksUtilization
(RackNo, PositionNo)
values(@RackNo, @PositionNo)
GO
/****** Object:  StoredProcedure [dbo].[PickENADataSheetAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[PickENADataSheetAdd]
(
	@RcvNo nvarchar(10) ,
	@ItemOption nvarchar(50),
	@ENA nvarchar(50),
	@Size nvarchar(50),
	@ItemColor nvarchar(50),
	@ItemDes nvarchar(100),
	@DateEnter datetime,
	@ItemDesUSA nvarchar(100),
	@EnterSource nvarchar(10),
	@SizeUSA nvarchar(50),
	@DepartmentCode varchar(20)
)
As
SET DATEFORMAT DMY;

INSERT INTO PickENADataSheet
	(
		RcvNo,
		ItemOption,
		ENA,
		Size,
		ItemColor,
		ItemDes,
		DateEnter,
		ItemDesUSA,
		EnterSource,
		SizeUSA,
		DepartmentCode
	)
values(
		@RcvNo,
		@ItemOption,
		ltrim(@ENA),
		@Size,
		@ItemColor,
		@ItemDes,
		@DateEnter,
		@ItemDesUSA,
		@EnterSource,
		@SizeUSA,
		@DepartmentCode
	)
GO
/****** Object:  StoredProcedure [dbo].[PickENADataSheetCorrect]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[PickENADataSheetCorrect]
(
@ItemOption nvarchar(50), @ENA nvarchar(50)
)
As
SET DATEFORMAT DMY;

Update PickENADataSheet
SET
ENA=@ENA
where
ItemOption=@ItemOption

GO
/****** Object:  StoredProcedure [dbo].[PickENADataSheetRcvdDateAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[PickENADataSheetRcvdDateAdd]
(
@ItemOption nvarchar(50), @DateEnter Datetime
)
As
SET DATEFORMAT DMY;

update  PickENADataSheet
set 
DateEnter=@DateEnter
where 
ItemOption=@ItemOption
GO
/****** Object:  StoredProcedure [dbo].[PickENADataSheetUpdate]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PickENADataSheetUpdate]
(
    @RcvNo NVARCHAR(10),
    @ItemOption NVARCHAR(50),
    @ENA NVARCHAR(50),
    @Size NVARCHAR(50),
    @ItemColor NVARCHAR(50),
    @ItemDes NVARCHAR(100),
    @DateEnter DATETIME,
    @ItemDesUSA NVARCHAR(100),
    @EnterSource NVARCHAR(10),
    @SizeUSA NVARCHAR(50),
	@DepartmentCode varchar(20)
)
AS
BEGIN
    SET DATEFORMAT DMY;

    UPDATE PickENADataSheet
    SET
        RcvNo = @RcvNo,
        Size = @Size,
        ItemColor = @ItemColor,
        ItemDes = @ItemDes,
        DateUpdate = @DateEnter,
        ItemDesUSA = @ItemDesUSA,
        EnterSource = @EnterSource,
		SizeUSA = @SizeUSA,
		DepartmentCode = @DepartmentCode
    WHERE
        ItemOption = @ItemOption AND
        ENA = LTRIM(@ENA);
END
GO
/****** Object:  StoredProcedure [dbo].[PickENADataSheetUSADesAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[PickENADataSheetUSADesAdd]
(
@ItemOption nvarchar(50), @ItemDesUSA nvarchar(100),@UpdateSource nvarchar(10)
)
As
SET DATEFORMAT DMY;

UPDATE PickENADataSheet
SET
ItemDesUSA=@ItemDesUSA,
UpdateSource=@UpdateSource
where
ItemOption=@ItemOption
GO
/****** Object:  StoredProcedure [dbo].[PickSplitENADataSheetAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PickSplitENADataSheetAdd]
(
	@ItemOption varchar(50),
	@Contract varchar(50), 
	@Delivery decimal, 
	@ReciveDate datetime, 
	@EnterSource nvarchar(10), 
	@DateEnter datetime
)
AS
BEGIN
    SET DATEFORMAT DMY;

    INSERT INTO SplitENADataSheet
    (
         ContractNo, 
		 DeliveryNo, 
		 ItemOption, 
		 DateEnter, 
		 EnterBy, 
		 ReciveDate
    )
    VALUES
    (
        @Contract,
        @Delivery,
        @ItemOption,
        @DateEnter,
		@EnterSource,
		@ReciveDate
    );
END
GO
/****** Object:  StoredProcedure [dbo].[PickSwingTicketDataAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[PickSwingTicketDataAdd]
(
@RcvNo nvarchar(10),@BarCode nvarchar(40),@SwingTicketBarCode nvarchar(40), @ErrorDes nvarchar(50)

)
AS
SET Dateformat DMY;
INSERT INTO PickSwingTicketData
(RcvNo, BarCode, SwingTicketBarCode, ErrorDes)
values
(@RcvNo, @BarCode, @SwingTicketBarCode, @ErrorDes)
GO
/****** Object:  StoredProcedure [dbo].[PickSwingTicketDataReworkDone]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[PickSwingTicketDataReworkDone]
(
@RcvNo nvarchar(10),@BarCode nvarchar(40),@SwingTicketBarCode nvarchar(40), @ErrorDes nvarchar(50)

)
AS
SET Dateformat DMY;
update PickSwingTicketData
SET 
ReworkOk=1
where
RcvNo=@RcvNo and BarCode=@BarCode and SwingTicketBarCode=@SwingTicketBarCode
GO
/****** Object:  StoredProcedure [dbo].[PicsExportAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[PicsExportAdd]
(
@BookingDate datetime, @VesselOrderNo decimal, @ContainerOrderNo decimal, @PicPath nvarchar(500),@Remarks nvarchar(500)
)
AS
INSERT INTO PicsExport
(BookingDate, VesselOrderNo, ContainerOrderNo, PicPath,Remarks)
values (@BookingDate, @VesselOrderNo, @ContainerOrderNo, @PicPath,@Remarks)
GO
/****** Object:  StoredProcedure [dbo].[PicsImportAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[PicsImportAdd]
(
@BookingDate datetime, @VesselOrderNo decimal, @ContainerOrderNo decimal, @PicPath nvarchar(500),@Remarks nvarchar(500)
)
AS
INSERT INTO PicsImport
(BookingDate, VesselOrderNo, ContainerOrderNo, PicPath,Remarks)
values (@BookingDate, @VesselOrderNo, @ContainerOrderNo, @PicPath,@Remarks)
GO
/****** Object:  StoredProcedure [dbo].[PicsReworkAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[PicsReworkAdd]
(
@RcvNo nvarchar(10), @PicPath nvarchar(500),@Remarks nvarchar(500)
)
AS
INSERT INTO PicsRework
(RcvNo, PicPath,Remarks)
values(@RcvNo, @PicPath,@Remarks)
GO
/****** Object:  StoredProcedure [dbo].[PicsTmpAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[PicsTmpAdd]
(
@UserId nvarchar(10), @PicPath nvarchar(100)
)
as
INSERT INTO PicsTmp
(UserId, PicPath)
values(@UserId, @PicPath)
GO
/****** Object:  StoredProcedure [dbo].[PicsTmpDelete]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[PicsTmpDelete]
(
@UserId nvarchar(10)
)
as
DELETE From PicsTmp
where UserId=@UserId
GO
/****** Object:  StoredProcedure [dbo].[PicsUnloadAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[PicsUnloadAdd]
(
@RcvNo nvarchar(10), @PicPath nvarchar(500),@Remarks nvarchar(500)
)
AS
INSERT INTO PicsUnload
(RcvNo, PicPath,Remarks)
values(@RcvNo, @PicPath,@Remarks)
GO
/****** Object:  StoredProcedure [dbo].[PlanCtnsSwap]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PlanCtnsSwap]
    @ContractNo NVARCHAR(50),
    @DeliveryNo DECIMAL(18, 0),
    @PlanCtns INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE CargoReceived
    SET Ctns = @PlanCtns
    WHERE ContractNo = @ContractNo
    AND DeliveryNo = @DeliveryNo;
END
GO
/****** Object:  StoredProcedure [dbo].[PMIssueContractAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[PMIssueContractAdd]
(
@RcvNo nvarchar(10), @PMCode nvarchar(12), @IssueQty decimal
)
AS
SET DATEFORMAT DMY;
INSERT INTO PMIssueContract
(RcvNo, PMCode, IssueQty)
Values(@RcvNo, @PMCode, @IssueQty)
GO
/****** Object:  StoredProcedure [dbo].[PMIssueContractEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[PMIssueContractEdit]
(
@RcvNo nvarchar(10), @PMCode nvarchar(12), @IssueQty decimal
)
AS
SET DATEFORMAT DMY;
UPDATE PMIssueContract
SET
IssueQty=IssueQty+@IssueQty
where
RcvNo=@RcvNo and PMCode= @PMCode
GO
/****** Object:  StoredProcedure [dbo].[PMMasterAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PMMasterAdd]
(
    @PMCode nvarchar(10), 
    @PMDescription nvarchar(50),
    @PMCategory nvarchar(50),
    @ReorderLevel int,
    @PMWeight decimal(18,2),
    @CBM decimal(18,2),
    @GetJokersCount bit,
    @GetPartsCount bit,
    @IsActive bit
)
AS
BEGIN
    SET DATEFORMAT DMY;

    INSERT INTO PMMaster (
        PMCode,
        PMDescription,
        PMCategory,
        QtyReOrderLevel,
        PMWgt,
        PMCBM,
        GetJokerCount,
		GetPartCount,
        IsActive
    )
    VALUES (
        @PMCode,
        @PMDescription,
        @PMCategory,
        @ReorderLevel,
        @PMWeight,
        @CBM,
        @GetJokersCount,
		@GetPartsCount,
        @IsActive
    );
END
GO
/****** Object:  StoredProcedure [dbo].[PMMasterEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PMMasterEdit]
(
    @PMCode nvarchar(10),
    @PMDescription nvarchar(50),
    @PMCategory nvarchar(50),
    @ReorderLevel int,
    @PMWeight decimal(18,2),
    @CBM decimal(18,2),
    @GetJokersCount bit,
    @GetPartsCount bit,
    @IsActive bit
)
AS
BEGIN
    SET DATEFORMAT DMY;

    UPDATE PMMaster
    SET PMDescription = @PMDescription,
        PMCategory = @PMCategory,
        QtyReOrderLevel = @ReorderLevel,
        PMWgt = @PMWeight,
        PMCBM = @CBM,
        GetJokerCount = @GetJokersCount,
        GetPartCount = @GetPartsCount,
        IsActive = @IsActive
    WHERE PMCODE = @PMCode;
END
GO
/****** Object:  StoredProcedure [dbo].[PMMasterStockDeduct]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[PMMasterStockDeduct]
(
@PMCode nvarchar(12), @QtyInHand decimal
)
AS
SET DATEFORMAT DMY;
UPDATE PMMaster 
set
QtyInHand=QtyInHand-@QtyInHand
where
PMCode=@PMCode
GO
/****** Object:  StoredProcedure [dbo].[PMMasterStockDeductWithCBM]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Changed ALTER to CREATE
CREATE PROCEDURE [dbo].[PMMasterStockDeductWithCBM]
(
    @PMCode nvarchar(12), 
    @QtyInHand decimal, 
    @CBM MONEY
)
AS
BEGIN
    SET DATEFORMAT DMY;
    SET NOCOUNT ON; -- Good practice to prevent extra result sets

    UPDATE PMMaster 
    SET QtyInHand = QtyInHand - @QtyInHand,
    StockCBM = StockCBM - @CBM
    WHERE PMCode = @PMCode;
END
GO
/****** Object:  StoredProcedure [dbo].[PMSupplierAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PMSupplierAdd]
(
    @PMSupplierCode nvarchar(5),
    @PMSupplierName nvarchar(50),
    @PMSupplierAddress1 nvarchar(50),
    @PMSupplierAddress2 nvarchar(50),
    @PMSupplierAddress3 nvarchar(50),
    @PMSupplierAddress4 nvarchar(50),
    @PMSupplierContact1 nvarchar(50),
    @PMSupplierContact2 nvarchar(50),
    @PMSupplierContact3 nvarchar(50),
    @PMSupplierTel nvarchar(50),
    @PMSupplierEmail nvarchar(50),
    @PMSupplierFax nvarchar(50),
    @CountryCode nvarchar(10)
)
AS
BEGIN
    SET DateFormat DMY;

    INSERT INTO PMSupplier
    (
        PMSupplierCode,
        PMSupplierName,
        PMSupplierAddress1,
        PMSupplierAddress2,
        PMSupplierAddress3,
        PMSupplierAddress4,
        PMSupplierContact1,
        PMSupplierContact2,
        PMSupplierContact3,
        PMSupplierTel,
        PMSupplierEmail,
        PMSupplierFax,
        CountryCode
    )
    VALUES
    (
        @PMSupplierCode,
        @PMSupplierName,
        @PMSupplierAddress1,
        @PMSupplierAddress2,
        @PMSupplierAddress3,
        @PMSupplierAddress4,
        @PMSupplierContact1,
        @PMSupplierContact2,
        @PMSupplierContact3,
        @PMSupplierTel,
        @PMSupplierEmail,
        @PMSupplierFax,
        @CountryCode
    );
END;
GO
/****** Object:  StoredProcedure [dbo].[PMSupplierEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PMSupplierEdit]
(
    @PMSupplierCode nvarchar(5),
    @PMSupplierName nvarchar(50),
    @PMSupplierAddress1 nvarchar(50),
    @PMSupplierAddress2 nvarchar(50),
    @PMSupplierAddress3 nvarchar(50),
    @PMSupplierAddress4 nvarchar(50),
    @PMSupplierContact1 nvarchar(50),
    @PMSupplierContact2 nvarchar(50),
    @PMSupplierContact3 nvarchar(50),
    @PMSupplierTel nvarchar(50),
    @PMSupplierEmail nvarchar(50),
    @PMSupplierFax nvarchar(50),
    @CountryCode nvarchar(10)
)
AS
BEGIN
    SET DateFormat DMY;

    UPDATE PMSupplier
    SET
        PMSupplierName = @PMSupplierName,
        PMSupplierAddress1 = @PMSupplierAddress1,
        PMSupplierAddress2 = @PMSupplierAddress2,
        PMSupplierAddress3 = @PMSupplierAddress3,
        PMSupplierAddress4 = @PMSupplierAddress4,
        PMSupplierContact1 = @PMSupplierContact1,
        PMSupplierContact2 = @PMSupplierContact2,
        PMSupplierContact3 = @PMSupplierContact3,
        PMSupplierTel = @PMSupplierTel,
        PMSupplierEmail = @PMSupplierEmail,
        PMSupplierFax = @PMSupplierFax,
        CountryCode = @CountryCode
    WHERE
        PMSupplierCode = @PMSupplierCode;
END;
GO
/****** Object:  StoredProcedure [dbo].[PortsAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[PortsAdd]
(@PortCode nvarchar(10), @PortName nvarchar(50), @CountryCode nvarchar(10) ,@IsDivertable bit, @CreateBy nvarchar(10))
AS
SET DATEFORMAT DMY;
INSERT INTO Ports
(PortCode, PortName, CountryCode, DateCreate, IsDivertable, CreateBy)
values(@PortCode, @PortName, @CountryCode, getdate(), @IsDivertable, @CreateBy)

GO
/****** Object:  StoredProcedure [dbo].[PortsEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[PortsEdit]
(@PortCode nvarchar(10), @PortName nvarchar(50), @CountryCode nvarchar(10),@IsDivertable bit, @UpdateBy nvarchar(10))
AS
SET DATEFORMAT DMY;
UPDATE Ports
set 
PortName=@PortName, 
CountryCode=@CountryCode, 
DateUpdate=getdate(), 
IsDivertable=@IsDivertable, 
UpdateBy=@UpdateBy

where PortCode=@PortCode



GO
/****** Object:  StoredProcedure [dbo].[PwInfoAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE       procedure  [dbo].[PwInfoAdd]
(@UserId nchar(4), @PassWord nchar(8), @UserName nvarchar(50), @DateCreate datetime, @UserLevel nvarchar(50), @IsNewOption bit, @IsEditOption bit, @IsPrintOption bit, @IsConfirmOption bit, @IsReConfirmOption bit, @IsSignOption bit, @IsCancelOption bit, @IsOtherOption bit,@isConfirmAC bit, @isReEdit bit)
as

SET DATEFORMAT DMY;
INSERT INTO PwInfo
(UserId, [PassWord],UserName, DateCreate, UserLevel, IsNewOption, IsEditOption, IsPrintOption, IsConfirmOption, IsReConfirmOption, IsSignOption, IsCancelOption, IsOtherOption,isConfirmAC, isReEdit)
VALUES (@UserId, @PassWord,@UserName,@DateCreate, @UserLevel, @IsNewOption, @IsEditOption, @IsPrintOption, @IsConfirmOption, @IsReConfirmOption, @IsSignOption, @IsCancelOption, @IsOtherOption,@isConfirmAC, @isReEdit)
RETURN












GO
/****** Object:  StoredProcedure [dbo].[PwInfoDCAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[PwInfoDCAdd]
(@UserId nvarchar(50), @DC nvarchar(50))
AS
SET DATEFORMAT DMY
INSERT INTO PwInfoDC
(UserId, DC)
values (@UserId, @DC)



GO
/****** Object:  StoredProcedure [dbo].[PwInfoDCDelete]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[PwInfoDCDelete]
(@UserId nvarchar(50))
AS
SET DATEFORMAT DMY
Delete from PwInfoDC
where
UserId=@UserId



GO
/****** Object:  StoredProcedure [dbo].[PwInfoEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE       procedure  [dbo].[PwInfoEdit]
(@UserId nchar(4),@PassWord nchar(8),@UserName nvarchar(50),@DateUpdate datetime, @UserLevel nvarchar(50), @IsNewOption bit, @IsEditOption bit, @IsPrintOption bit, @IsConfirmOption bit, @IsReConfirmOption bit, @IsSignOption bit, @IsCancelOption bit, @IsOtherOption bit,@isConfirmAC bit, @isReEdit bit)

as
SET DATEFORMAT DMY;
UPDATE PwInfo SET
UserId=@UserId,
[PassWord]=@Password,
UserName=@UserName,
DateUpdate=@DateUpdate,
UserLevel=@UserLevel,
IsNewOption=@IsNewOption, 
IsEditOption=@IsEditOption, 
IsPrintOption=@IsPrintOption, 
IsConfirmOption=@IsConfirmOption, 
IsReConfirmOption=@IsReConfirmOption, 
IsSignOption=@IsSignOption, 
IsCancelOption=@IsCancelOption,
IsOtherOption=@IsOtherOption,
isConfirmAC=@isConfirmAC, 
isReEdit=@isReEdit
Where UserID = @UserId
RETURN














GO
/****** Object:  StoredProcedure [dbo].[PwInfoShippersAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[PwInfoShippersAdd]
(@UserId nvarchar(50), @ShipperCode nvarchar(10))
AS
SET DATEFORMAT DMY
INSERT INTO PwInfoShippers
(UserId, ShipperCode)
values (@UserId, @ShipperCode)



GO
/****** Object:  StoredProcedure [dbo].[PwInfoShippersDelete]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[PwInfoShippersDelete]
(@UserId nvarchar(50))
AS
SET DATEFORMAT DMY
Delete from PwInfoShippers
where
UserId=@UserId



GO
/****** Object:  StoredProcedure [dbo].[QCStaffAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create     PROCEDURE [dbo].[QCStaffAdd]
(
@StaffCode nvarchar(5), @StaffName nvarchar(50),@DateEnter datetime, @EnterBy nvarchar(4)
)
AS
SET DATEFORMAT DMY;
INSERT INTO QCStaff
(StaffCode, StaffName,DateEnter,EnterBy)
VALUES
(@StaffCode, @StaffName,@DateEnter,@EnterBy)







GO
/****** Object:  StoredProcedure [dbo].[QCStaffEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




create     PROCEDURE [dbo].[QCStaffEdit]
(
@StaffCode nvarchar(5), @StaffName nvarchar(50), @DateUpdate datetime, @UpdateBy nvarchar(5)
)
AS 
SET DATEFORMAT DMY;
UPDATE QCStaff SET
StaffCode = @StaffCode,
StaffName = @StaffName,
DateUpdate=@DateUpdate,
UpdateBy=@UpdateBy
WHERE StaffCode = @StaffCode







GO
/****** Object:  StoredProcedure [dbo].[RemoveCargoReceivedVesselPlan]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RemoveCargoReceivedVesselPlan]
    @RcvNo NVARCHAR(10)
AS
BEGIN
    -- Update CargoReceived table
    UPDATE CargoReceived
    SET BookingDate = NULL,
        VesselOrderNo = 0,
        ContainerOrderNo = 0,
        RemoveStatus = '',
        RemoveQty = 0
        --Authorized = 0,
        --ApprvReqStatus = '', 
        --ApprvReqTime = NULL, 
        --ApprvReqBy = '', 
        --ApprvToShip = '', 
        --ApprvToShipBy = '', 
        --ApprvToShipTime = NULL, 
        --nApprvToShip = '', 
        --nApprvToShipBy = '', 
        --nApprvToShipTime = NULL,
        --nApprvToShipAction = '', 
        --nApprvToShipActionTime = NULL, 
        --nApprvToShipActionBy = ''
    WHERE RcvNo = @RcvNo;

    -- Update CargoBarCode table
    UPDATE CargoBarCode
    SET Status = '',
    ExportPalletNo='0'
    WHERE RcvNo = @RcvNo;

    -- Update CargoBarcodeCtnOut table
    UPDATE CargoBarcodeCtnOut
    SET Status = ''
    WHERE RcvNo = @RcvNo;

  -- Update CargoManualBox table                             
    UPDATE CargoManualBox                                       
    SET Status = '',                                            
    ExportPalletNo = 0                                          
    WHERE RcvNo = @RcvNo;                                                                          
END;
GO
/****** Object:  StoredProcedure [dbo].[RemoveFromUnload]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RemoveFromUnload]
    @RcvNo VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Update CargoReceived status metrics
        UPDATE CargoReceived
        SET ScanQty = 0, 
            InQty = 0, 
            UnloadStatus = '', 
            UnloadBy = '', 
            UnloadTimeSys = NULL
        WHERE RcvNo = @RcvNo;

        -- 2. Delete associated records from child tables
        DELETE FROM CargoBarCode 
        WHERE RcvNo = @RcvNo;

        DELETE FROM CargoManualBox 
        WHERE RcvNo = @RcvNo;

        DELETE FROM CargoPallets 
        WHERE RcvNo = @RcvNo;

        -- If everything succeeded, commit the changes
        COMMIT TRANSACTION;
        
        PRINT 'Cargo data for ' + @RcvNo + ' has been reset successfully.';
    END TRY
    BEGIN CATCH
        -- If an error occurs, undo all changes
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Raise the error details
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[RFIDDataAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[RFIDDataAdd]
(
 @ContractNo nvarchar(20), @ItemNo nvarchar(10),@DCMain nvarchar(20), @GlobalBrand nvarchar(50),@GarmentType nvarchar(50),@Phase nvarchar(10),@SupplierRef nvarchar(50),@DateEnter datetime,@DeliveryNo decimal,@ItemOptionLookup varchar(10),@NofParts decimal
)
AS
SET DATEFORMAT DMY;
INSERT INTO RFIDData
(ContractNo, ItemNo,DCMain, GlobalBrand, GarmentType, Phase, SupplierRef, DateEnter,DeLiveryNo,ItemOptionLookup,NofParts)
values(@ContractNo, @ItemNo,@DCMain, @GlobalBrand, @GarmentType, @Phase, @SupplierRef, @DateEnter,@DeliveryNo,@ItemOptionLookup,@NofParts)
GO
/****** Object:  StoredProcedure [dbo].[RFIDDataDtlAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[RFIDDataDtlAdd]
(
 @ContractNo nvarchar(20),@ItemNo nvarchar(10),@DCMain nvarchar(20),@DateEnter datetime,@ItemOption nvarchar(10),@PartSet nvarchar(50), @EAN nvarchar(50), @ItemDes varchar(50), @ItemSize nvarchar(50), @ItemColor nvarchar(50), @RtlPrice money, @Qty decimal, @NofParts decimal, @NofJokers decimal,@Department nvarchar(20),@DeliveryNo decimal
)
AS
SET DATEFORMAT DMY;
INSERT INTO RFIDDataDtl
(ContractNo, ItemNo,DcMain,DateEnter, ItemOption, PartSet, EAN, ItemDes, ItemSize, ItemColor, RtlPrice, Qty, NofParts, NofJokers,QtyBal,Department,DeliveryNo)
values(@ContractNo, @ItemNo,@DCMain,@DateEnter, @ItemOption, @PartSet, @EAN, @ItemDes, @ItemSize, @ItemColor, @RtlPrice, @Qty, @NofParts, @NofJokers,@qty,@Department,@DeliveryNo)
GO
/****** Object:  StoredProcedure [dbo].[RFIDDataDtlEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[RFIDDataDtlEdit]
(
 @ContractNo nvarchar(20),@ItemNo nvarchar(10),@ItemOption nvarchar(10),@PartSet nvarchar(50), @EAN nvarchar(50), @ItemDes varchar(50), @ItemSize nvarchar(50), @ItemColor nvarchar(50), @RtlPrice money, @Qty decimal, @NofParts decimal, @NofJokers decimal
)
AS
SET DATEFORMAT DMY;
UPDATE RFIDDataDtl
SET
PartSet=@PartSet, 
EAN=@EAN, 
ItemDes=@ItemDes, 
ItemSize=@ItemSize, 
ItemColor=@ItemColor, 
RtlPrice=@RtlPrice, 
Qty=@Qty, 
NofParts=@NofParts, 
NofJokers=@NofJokers,
QtyBal=@Qty
where
ContractNo=@ContractNo and ItemNo=@ItemNo and ItemOption=@ItemOption
GO
/****** Object:  StoredProcedure [dbo].[RFIDDataEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[RFIDDataEdit]
(
 @ContractNo nvarchar(20), @ItemNo nvarchar(10), @GlobalBrand nvarchar(50),@GarmentType nvarchar(50),@Phase nvarchar(10),@SupplierRef nvarchar(50),@DateEnter datetime
)
AS
SET DATEFORMAT DMY;
UPDATE RFIDData
SET
GlobalBrand=@GlobalBrand, 
GarmentType=@GarmentType, 
Phase=@Phase, 
SupplierRef=@SupplierRef
where
ContractNo=@ContractNo and ItemNo=@ItemNo
GO
/****** Object:  StoredProcedure [dbo].[RFIDDataHangersAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[RFIDDataHangersAdd]
(
@ItemOption nvarchar(10), @H497 decimal, @H498 decimal, @H6008 decimal, @H6010 decimal, @H3315 decimal
)
AS
SET DATEFORMAT DMY;
INSERT INTO RFIDDataHangers
(ItemOption, H497, H498, H6008, H6010, H3315)
Values(@ItemOption, @H497, @H498, @H6008, @H6010, @H3315) 
GO
/****** Object:  StoredProcedure [dbo].[RFIDDataHangersEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[RFIDDataHangersEdit]
(
@ItemOption nvarchar(10), @H497 decimal, @H498 decimal, @H6008 decimal, @H6010 decimal, @H3315 decimal
)
AS
SET DATEFORMAT DMY;
UPDATE RFIDDataHangers
SET
H497=@H497, 
H498=@H498, 
H6008=@H6008, 
H6010=@H6010, 
H3315=@H3315
where
ItemOption=@ItemOption 
GO
/****** Object:  StoredProcedure [dbo].[RFIDDataItemOptionLookupAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[RFIDDataItemOptionLookupAdd]
(
@ContractNo varchar(20),@DeliveryNo decimal,@DC VARCHAR(50)
)
AS
SET DATEFORMAT DMY;

UPDATE RFIDData 
set

ItemOptionLookup='Update',
DC=@DC
where
ContractNo=@ContractNo 
and
DeliveryNo=@DeliveryNo
GO
/****** Object:  StoredProcedure [dbo].[RFIDOrderRefSave]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RFIDOrderRefSave]
    @OrderRef VARCHAR(50),
    @SelectDate DATETIME,
    @OrderBy VARCHAR(50),
    @SysDate DATETIME,
    @Status VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @Status = 'Requested'
    BEGIN
        INSERT INTO RFIDOrderRef (OrderRef, OrderDate, OrderBy, OrderDateSys, DateLastUpdate, Status)
        VALUES (@OrderRef, @SelectDate, @OrderBy, @SysDate, @SysDate, @Status);
    END
    ELSE IF @Status = 'Received'
    BEGIN
        UPDATE RFIDOrderRef
        SET RcvdDate = @SelectDate,
            RcvdDateSys = @SysDate,
            RcvdEnterBy = @OrderBy,
			DateLastUpdate=@SysDate,
			Status=@Status
        WHERE OrderRef = @OrderRef;
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[saveAndUpdateCartonSplit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[saveAndUpdateCartonSplit]
    @RcvNo NVARCHAR(50),
    @Barcode NVARCHAR(50)
AS
BEGIN
    -- Start a transaction
    BEGIN TRANSACTION;

 -- Get the ItemOption from the deleted CargoBarCode record
    DECLARE @ItemOption VARCHAR(50);
    SELECT @ItemOption = ItemOption
    FROM CargoBarCode
    WHERE BarCode = @Barcode AND RcvNo = @RcvNo;
	
    -- Delete from CargoBarCode
    DELETE FROM CargoBarCode
    WHERE BarcodeAudit = '' AND BarCode = @Barcode AND RcvNo = @RcvNo;

    -- Update CargoReceived
    UPDATE CargoReceived
    SET 
        ScanQty = ScanQty - 1,
        InQty = InQty - 1,
		SplittedCtns = SplittedCtns+1,
        PickPackStatus = CASE WHEN InQty - 1 = ReWorkQty THEN 'Finish' ELSE PickPackStatus END,
        PCSValidationStatus = CASE WHEN InQty - 1 = ValidateQty THEN 'Finish' ELSE PCSValidationStatus END
    WHERE RcvNo = @RcvNo;
	

	-- Get ContractNo and DeliveryNo from CargoReceived
    DECLARE @ContractNo NVARCHAR(50), @DeliveryNo NVARCHAR(50);
    SELECT 
        @ContractNo = ContractNo,
        @DeliveryNo = DeliveryNo
    FROM CargoReceived
    WHERE RcvNo = @RcvNo;

    -- Update SplitENADataSheet
    UPDATE SplitENADataSheet
    SET IsSplited = 1
    WHERE ContractNo = @ContractNo
      AND DeliveryNo = @DeliveryNo
      AND ItemOption = @ItemOption;


    -- Delete from CargoItemOption if Ctns = 1
    DELETE FROM CargoItemOption
    WHERE RcvNo = @RcvNo AND ItemOption = @ItemOption AND Ctns = 1;
	
    -- Update CargoItemOption
    UPDATE CargoItemOption
    SET Ctns = CASE WHEN Ctns > 1 THEN Ctns - 1 ELSE Ctns END
    WHERE RcvNo = @RcvNo AND ItemOption = @ItemOption;


    -- Insert into BarcodeSplit
    INSERT INTO BarcodeSplit (RcvNo, Barcode, EAN, ItemSize, ItemColor, Qty)
    VALUES (@RcvNo, @Barcode, '', '', '', 0);



    -- Commit the transaction
    COMMIT TRANSACTION;
END;
GO
/****** Object:  StoredProcedure [dbo].[saveAndUpdateManualCartonSplit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[saveAndUpdateManualCartonSplit]
    @RcvNo NVARCHAR(50),
    @ItemOption NVARCHAR(50),
	@Ctns  decimal
AS
BEGIN
    -- Start a transaction
    BEGIN TRANSACTION;

 -- Get the ItemOption from the deleted CargoBarCode record
    -- DECLARE @ItemOption VARCHAR(50);
    -- SELECT @ItemOption = ItemOption
    -- FROM CargoBarCode
    -- WHERE BarCode = @Barcode AND RcvNo = @RcvNo;
	
    -- Delete from CargoBarCode
    -- DELETE FROM CargoBarCode
    -- WHERE BarcodeAudit = '' AND BarCode = @Barcode AND RcvNo = @RcvNo;

    -- Update CargoReceived
    UPDATE CargoReceived
    SET 
        ScanQty = ScanQty - @Ctns,
        InQty = InQty - @Ctns,
		SplittedCtns = SplittedCtns+@Ctns,
        PickPackStatus = CASE WHEN InQty - @Ctns = ReWorkQty THEN 'Finish' ELSE PickPackStatus END,
        PCSValidationStatus = CASE WHEN InQty - @Ctns = ValidateQty THEN 'Finish' ELSE PCSValidationStatus END
    WHERE RcvNo = @RcvNo;
	
	-- DECLARE @Ctns decimal;
    -- SELECT @Ctns=Ctns FROM CargoItemOption
    -- WHERE RcvNo = @RcvNo AND ItemOption = @ItemOption ;
	
	-- Get ContractNo and DeliveryNo from CargoReceived
    DECLARE @ContractNo NVARCHAR(50), @DeliveryNo NVARCHAR(50);
    SELECT 
        @ContractNo = ContractNo,
        @DeliveryNo = DeliveryNo
    FROM CargoReceived
    WHERE RcvNo = @RcvNo;

    -- Update SplitENADataSheet
    UPDATE SplitENADataSheet
    SET IsSplited = 1
    WHERE ContractNo = @ContractNo
      AND DeliveryNo = @DeliveryNo
      AND ItemOption = @ItemOption;
	
	
    -- Delete from CargoItemOption if Ctns = 1
    DELETE FROM CargoItemOption
    WHERE RcvNo = @RcvNo AND ItemOption = @ItemOption AND Ctns = @Ctns;
	
    -- Update CargoItemOption
    UPDATE CargoItemOption
    SET Ctns = CASE WHEN Ctns > @Ctns THEN Ctns - @Ctns ELSE Ctns END
    WHERE RcvNo = @RcvNo AND ItemOption = @ItemOption;


    -- Insert into BarcodeSplit
    INSERT INTO BarcodeSplit (RcvNo, Barcode, EAN, ItemSize, ItemColor, Qty, Ctns)
    VALUES (@RcvNo, @ItemOption, '', '', '', 0, @Ctns);

    -- Commit the transaction
    COMMIT TRANSACTION;
END;
GO
/****** Object:  StoredProcedure [dbo].[SaveDivertLocation]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SaveDivertLocation]
(
    @ContractNo NVARCHAR(50),
    @DeliveryNo DECIMAL(18, 0),
    @DivertLocation NVARCHAR(50),
    @DivertLocationDate DATETIME
)
AS
BEGIN
    SET NOCOUNT ON;
	Declare @ReworkApply bit;
	SET @ReworkApply=0;
    UPDATE CargoReceived
    SET 
        DivertLocation = @DivertLocation,
        DivertLocationDate = @DivertLocationDate,
        ReWorkQty = CASE WHEN @ReworkApply = 0 THEN InQty ELSE 0 END,
		InPCS = CASE WHEN @ReworkApply = 0 THEN PCS ELSE 0 END,
		PickPackStatus = CASE WHEN @ReworkApply = 0 THEN 'Finish' ELSE '' END,
		PickPackStatusBy = CASE WHEN @ReworkApply = 0 THEN UnloadBy ELSE '' END,
		PickPackStatusTime = CASE WHEN @ReworkApply = 0 THEN GETDATE() ELSE null END
    WHERE 
        ContractNo = @ContractNo
        AND DeliveryNo = @DeliveryNo;

	 -- Update SplitENADataSheet
    UPDATE SplitENADataSheet
    SET IsSplited = 1
    WHERE ContractNo = @ContractNo
      AND DeliveryNo = @DeliveryNo;


END
GO
/****** Object:  StoredProcedure [dbo].[SeaRatesAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SeaRatesAdd]
(
@Stuffing40_CBM money, @Stuffing20_CBM money, @BLFee_BL money, @Rigging_Bar money, @Hanging_Bar money, @Partion_Cntr money, @MgmtFee_20 money, @MgmtFee_40 money, @UpdateBy nvarchar(10), @UpdateTime datetime
)
AS
SET DATEFORMAT DMY;
Update SeaRates
SET
Stuffing40_CBM=@Stuffing40_CBM, 
Stuffing20_CBM=@Stuffing20_CBM, 
BLFee_BL=@BLFee_BL, 
Rigging_Bar=@Rigging_Bar, 
Hanging_Bar=@Hanging_Bar, 
Partion_Cntr=@Partion_Cntr, 
MgmtFee_20=@MgmtFee_20, 
MgmtFee_40=@MgmtFee_40, 
UpdateBy=@UpdateBy, 
UpdateTime=@UpdateTime




GO
/****** Object:  StoredProcedure [dbo].[ShipmentChangeTrackingAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ShipmentChangeTrackingAdd]
(
@RcvNo nvarchar(10), @DateDone datetime, @DoneBy nvarchar(10), @Activity nvarchar(40), @Remarks nvarchar(400)
)
AS
SET DATEFORMAT DMY;
INSERT INTO 
ShipmentChangeTracking
(RcvNo, DateDone, DoneBy, Activity, Remarks)
values(@RcvNo, @DateDone, @DoneBy, @Activity,@Remarks)


GO
/****** Object:  StoredProcedure [dbo].[ShipperAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ShipperAdd]
(
@ShipperCode nvarchar(5), @ShipperName nvarchar(50), @ShipperAddress1 nvarchar(50), @ShipperAddress2 nvarchar(50), @ShipperAddress3 nvarchar(50), @ShipperAddress4 nvarchar(50), @ShipperContact1 nvarchar(50), @ShipperContact2 nvarchar(50), @ShipperContact3 nvarchar(50),  @CreateBy nvarchar(5), @ShipperCodeAir nvarchar(5), @ShipperCodeSea nvarchar(5), @ShipperTel nvarchar(50), @ShipperEmail nvarchar(50), @ShipperFax nvarchar(50),@CountryCode nvarchar(10), @LimaSupplierCode nvarchar(10), @REXNo nvarchar(50)
)

as 
SET DateFormat DMY;

INSERT INTO
Shipper
(ShipperCode, ShipperName, ShipperAddress1, ShipperAddress2, ShipperAddress3, ShipperAddress4, ShipperContact1, ShipperContact2, ShipperContact3, DateCreate, CreateBy, ShipperCodeAir, ShipperCodeSea, ShipperTel, ShipperEmail, ShipperFax,CountryCode,LimaSupplierCode,REXNo)
Values
(@ShipperCode, @ShipperName, @ShipperAddress1, @ShipperAddress2, @ShipperAddress3, @ShipperAddress4, @ShipperContact1, @ShipperContact2, @ShipperContact3, getdate(), @CreateBy, @ShipperCodeAir, @ShipperCodeSea, @ShipperTel, @ShipperEmail, @ShipperFax,@CountryCode,@LimaSupplierCode,@REXNo)



GO
/****** Object:  StoredProcedure [dbo].[ShipperEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ShipperEdit]
(
@ShipperCode nvarchar(5), @ShipperName nvarchar(50), @ShipperAddress1 nvarchar(50), @ShipperAddress2 nvarchar(50), @ShipperAddress3 nvarchar(50), @ShipperAddress4 nvarchar(50), @ShipperContact1 nvarchar(50), @ShipperContact2 nvarchar(50), @ShipperContact3 nvarchar(50),  @UpdateBy nvarchar(5), @ShipperCodeAir nvarchar(5), @ShipperCodeSea nvarchar(5), @ShipperTel nvarchar(50), @ShipperEmail nvarchar(50), @ShipperFax nvarchar(50),@CountryCode nvarchar(10), @LimaSupplierCode nvarchar(10), @REXNo nvarchar(50)
)

as 
SET DateFormat DMY;

UPDATE Shipper
Set
ShipperCode=@ShipperCode, 
ShipperName=@ShipperName, 
ShipperAddress1=@ShipperAddress1, 
ShipperAddress2=@ShipperAddress2, 
ShipperAddress3=@ShipperAddress3, 
ShipperAddress4=@ShipperAddress4, 
ShipperContact1=@ShipperContact1, 
ShipperContact2=@ShipperContact2, 
ShipperContact3=@ShipperContact3, 
DateUpdate=getdate(),
UpdateBy=@UpdateBy, 
ShipperCodeAir=@ShipperCodeAir, 
ShipperCodeSea=@ShipperCodeSea, 
ShipperTel=@ShipperTel, 
ShipperEmail=@ShipperEmail, 
ShipperFax=@ShipperFax,
CountryCode=@CountryCode,
LimaSupplierCode=@LimaSupplierCode,
REXNo=@REXNo

where
ShipperCode=@ShipperCode




GO
/****** Object:  StoredProcedure [dbo].[UpdateBarcodeSplit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateBarcodeSplit]
    @RcvNo VARCHAR(10),
    @Barcode VARCHAR(40),
    @Qty DECIMAL(18, 0),
    @SplitDeliveryId VARCHAR(20)
AS
BEGIN
    UPDATE BarcodeSplit
    SET Qty = @Qty, SplitDeliveryId = @SplitDeliveryId
    WHERE RcvNo = @RcvNo AND Barcode = @Barcode;
END;
GO
/****** Object:  StoredProcedure [dbo].[UpdateBarcodeSplitDeliveryLastId]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateBarcodeSplitDeliveryLastId]
    @SplitDeliveryNo DECIMAL(18, 0),
    @SplitDeliveryYear DECIMAL(18, 0)
AS
BEGIN
    UPDATE BarcodeSplitDeliveryLastId
    SET SplitDeliveryNo = @SplitDeliveryNo
    WHERE SplitDeliveryYear = @SplitDeliveryYear;
END;
GO
/****** Object:  StoredProcedure [dbo].[UpdateCargoReceivedHoldStatus]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Create the stored procedure
CREATE PROCEDURE [dbo].[UpdateCargoReceivedHoldStatus]
    @RcvNo NVARCHAR(10),
    @HoldStatus NVARCHAR(20),
    @HoldReason NVARCHAR(100),
    @HoldDate DATETIME
AS
BEGIN
    -- Set the date format
    SET DATEFORMAT DMY;

    -- Update the CargoReceived table
	IF @HoldStatus = 'Hold'
		BEGIN
			 UPDATE CargoReceived
			SET
				HoldStatus = @HoldStatus,
				HoldReason = @HoldReason,
				HoldDate=CASE 
                                WHEN HoldDate IS NULL THEN @HoldDate 
                                ELSE HoldDate 
                            END
			WHERE
				RcvNo = @RcvNo;
		END

   
	IF @HoldStatus = ''
		BEGIN
			 UPDATE CargoReceived
			SET
				HoldStatus = @HoldStatus,
				HoldReason = '',
				HoldReleaseDate=@HoldDate
			WHERE
				RcvNo = @RcvNo;
		END

    -- Determine the Status value
    DECLARE @Status NVARCHAR(20);
    IF @HoldStatus = ''
        SET @Status = 'Release';
    ELSE
        SET @Status = @HoldStatus;

    -- Insert into the BookingStatusDetails table
    INSERT INTO BookingStatusDetails (Status, Reason, [Date],RcvNo)
    VALUES (@Status, @HoldReason, @HoldDate, @RcvNo);
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateContainerTallySheetStatus]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateContainerTallySheetStatus]
    @BookingDate DATETIME,
    @VesselOrderNumber DECIMAL,
    @ContainerOrderNumber DECIMAL
AS
BEGIN
    -- Update the IsTallyUpload field to True where the conditions match
    UPDATE ContainerData
    SET IsTallyUpload = 1
    WHERE BookingDate = @BookingDate
      AND VesselOrderNo = @VesselOrderNumber
      AND ContainerOrderNo = @ContainerOrderNumber;
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateFirewallStatus]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateFirewallStatus]
    @RcvNo NVARCHAR(10),
    @FirewallStatusBy NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    SET DATEFORMAT DMY;

    UPDATE CargoReceived
    SET
        FirewallQty = FirewallQty + 1,
        FirewallStatusBy = @FirewallStatusBy,
        FirewallStatusDoneTime = GETDATE(),
        FirewallStatus = CASE
                             WHEN PackQty = FirewallQty + 1 AND PickPackStatus <> '' THEN 'Finish'
                             ELSE ''
                         END
    WHERE
        RcvNo = @RcvNo;
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateManualFirewallStatus]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpdateManualFirewallStatus]
    @Barcode NVARCHAR(40),
    @RcvNo NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    -- Update the FirewallOK column to "Finish" for the specified Barcode and RcvNo
    UPDATE CargoManualBox
    SET FirewallOK = 1
    WHERE Barcode = @Barcode
    AND RcvNo = @RcvNo;
END;
GO
/****** Object:  StoredProcedure [dbo].[UpdateRfidOrderRecived]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateRfidOrderRecived]
	@ContractNo NVARCHAR(20),
    @DeliveryNo NVARCHAR(10),
    @RfidOrder NVARCHAR(10),
    @RfidOrderDate DATETIME,
	@OrderRef VARCHAR(16)
AS
BEGIN
    -- Start a transaction
    BEGIN TRANSACTION;

    -- Update the CargoReceived table based on conditions
    IF @RfidOrder = 'Requested'
    BEGIN
        UPDATE CargoReceived
        SET 
            RfidOrder = @RfidOrder,
            RfidOrderDate = @RfidOrderDate
        WHERE 
            ContractNo = @ContractNo
			and DeliveryNo = @DeliveryNo;

        UPDATE RFIDData
        SET 
            RFIDOrderStatus = @RfidOrder,
            RFIDOrderDate = @RfidOrderDate,
			RFIDOrderRef = @OrderRef
        WHERE 
            ContractNo = @ContractNo
			and DeliveryNo = @DeliveryNo;
    END
    ELSE IF @RfidOrder = 'Received'
    BEGIN
        UPDATE CargoReceived
        SET 
            RfidOrder = @RfidOrder,
            RfidAvailableDate = @RfidOrderDate
        WHERE  
            ContractNo = @ContractNo
			and DeliveryNo = @DeliveryNo;

		 UPDATE RFIDData
        SET 
            RFIDOrderStatus = @RfidOrder,
            RfidAvailableDate = @RfidOrderDate,
			RFIDOrderRef = @OrderRef
        WHERE 
            ContractNo = @ContractNo
			and DeliveryNo = @DeliveryNo;
    END

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
    BEGIN
        -- If no rows were updated, rollback the transaction and return an error
        ROLLBACK TRANSACTION;
        RAISERROR('No rows updated. Please check the RcvNo value.', 16, 1);
        RETURN;
    END

    -- If everything is okay, commit the transaction
    COMMIT TRANSACTION;

    -- Return a success message
    PRINT 'Update successful.';
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateRFIDShortage]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateRFIDShortage]
    @BarCode NVARCHAR(40),
    @RcvNo NVARCHAR(10),
    @NewRFIDShortage DECIMAL(18, 0)
AS
BEGIN
    SET NOCOUNT ON;

    -- Update RFIDShortage based on BarCode and RcvNo
        UPDATE CargoBarCode
    SET RFIDShortage = RFIDShortage + @NewRFIDShortage
    WHERE BarCode = @BarCode AND RcvNo = @RcvNo;
END;
GO
/****** Object:  StoredProcedure [dbo].[UpdateScanFirewallStatus]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateScanFirewallStatus]
    @Barcode NVARCHAR(40),
    @RcvNo NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    -- Update the FirewallOK column to "Finish" for the specified Barcode and RcvNo
    UPDATE CargoBarCode
    SET FirewallOK = 1
    WHERE Barcode = @Barcode
    AND RcvNo = @RcvNo;
END;
GO
/****** Object:  StoredProcedure [dbo].[UserRightsAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE        proc [dbo].[UserRightsAdd]
(
@TreeViewFullPath nvarchar(200),
@UserId nvarchar(4)
)
as
Insert into UserRights
(TreeViewFullPath, UserId)
values (@TreeViewFullPath, @UserId)
return


GO
/****** Object:  StoredProcedure [dbo].[VesselRegistryAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[VesselRegistryAdd]
(
@BookingDate DateTime, @VesselOrderNo decimal, @VesselName nvarchar(50), @VoyageNo nvarchar(20), @ETD DateTime, @CutOff datetime, @OnBoard datetime, @ETA datetime, @DateEnter datetime, @EnterBy nvarchar(10), @VesselBookingNo nvarchar(20),@Carrier nvarchar(50), @DestPort nvarchar(30),@VoyageNoLima nvarchar(20),
@MBLNo nvarchar(50),@DC nvarchar(50),@DestCountry nvarchar(10)
)
AS
SET DATEFORMAT DMY;
INSERT INTO
VesselRegistry
(BookingDate, VesselOrderNo, VesselName, VoyageNo, ETD, CutOff, OnBoard, ETA, DateEnter, EnterBy, VesselBookingNo,Carrier,DestPort,VoyageNoLima,MBLNo,DC,DestCountry)
values
(@BookingDate, @VesselOrderNo, @VesselName, @VoyageNo, @ETD, @CutOff, @OnBoard, @ETA, @DateEnter, @EnterBy, @VesselBookingNo,@Carrier,@DestPort,@VoyageNoLima,@MBLNo,@DC,@DestCountry)


GO
/****** Object:  StoredProcedure [dbo].[VesselRegistryEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   Procedure [dbo].[VesselRegistryEdit]
(
@BookingDate DateTime, @VesselOrderNo decimal, @VesselName nvarchar(50), @VoyageNo nvarchar(20), @ETD DateTime, @CutOff datetime, @OnBoard datetime, @ETA datetime, @DateUpdate datetime, @UpdateBy nvarchar(10), @VesselBookingNo nvarchar(20),@Carrier nvarchar(50), @DestPort nvarchar(30),@VoyageNoLima nvarchar(20),
@MBLNo nvarchar(50),@DC nvarchar(50),@DestCountry nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE
VesselRegistry
SET
VesselName=@VesselName,
VoyageNo=@VoyageNo,
ETD=@ETD,
CutOff=@CutOff,
OnBoard=@OnBoard,
ETA=@ETA,
VesselBookingNo=@VesselBookingNo,
Carrier=@Carrier,
DestPort=@DestPort,
VoyageNoLima=@VoyageNoLima,
MBLNo=@MBLNo,
DateUpdate=GETDATE(),
UpdateBy=@UpdateBy,
DC=@DC,
DestCountry=@DestCountry
where
BookingDate=@BookingDate and VesselOrderNo=@VesselOrderNo



GO
/****** Object:  StoredProcedure [dbo].[VesselRegistryImportAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[VesselRegistryImportAdd]
(
@BookingDate DateTime, @VesselOrderNo decimal, @VesselName nvarchar(50), @VoyageNo nvarchar(20), @ETD DateTime, @CutOff datetime, @OnBoard datetime, @ETA datetime, @DateEnter datetime, @EnterBy nvarchar(10), @VesselBookingNo nvarchar(20),@Carrier nvarchar(50), @DestPort nvarchar(30),@VoyageNoLima nvarchar(20),
@MBLNo nvarchar(50),@CountryCode nvarchar(10)
)
AS
SET DATEFORMAT DMY;
INSERT INTO
VesselRegistryImport
(BookingDate, VesselOrderNo, VesselName, VoyageNo, ETD, CutOff, OnBoard, ETA, DateEnter, EnterBy, VesselBookingNo,Carrier,DestPort,VoyageNoLima,MBLNo,CountryCode)
values
(@BookingDate, @VesselOrderNo, @VesselName, @VoyageNo, @ETD, @CutOff, @OnBoard, @ETA, @DateEnter, @EnterBy, @VesselBookingNo,@Carrier,@DestPort,@VoyageNoLima,@MBLNo,@CountryCode)



GO
/****** Object:  StoredProcedure [dbo].[VesselRegistryImportArrivalStatusUpdate]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create  Procedure [dbo].[VesselRegistryImportArrivalStatusUpdate]
(
@BookingDate DateTime, @VesselOrderNo decimal, @VesselName nvarchar(50),@Carrier nvarchar(50), @VoyageNo nvarchar(20),@ETD DateTime,@ETA DateTime,@MBLNo nvarchar(50)

)
AS
SET DATEFORMAT DMY;
UPDATE
VesselRegistryImport
SET
VesselName=@VesselName,
Carrier=@Carrier,
VoyageNo=@VoyageNo,
ETD=@ETD,
ETA=@ETA,
MBLNo=@MBLNo,
ArrivalStatus='Update'

where
BookingDate=@BookingDate and VesselOrderNo=@VesselOrderNo
GO
/****** Object:  StoredProcedure [dbo].[VesselRegistryImportConfirmArrival]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[VesselRegistryImportConfirmArrival]
(
@BookingDate DateTime, @VesselOrderNo decimal, @VesselName nvarchar(50)

)
AS
SET DATEFORMAT DMY;
UPDATE
VesselRegistryImport
SET
VesselName=@VesselName

where
BookingDate=@BookingDate and VesselOrderNo=@VesselOrderNo



GO
/****** Object:  StoredProcedure [dbo].[VesselRegistryImportEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   Procedure [dbo].[VesselRegistryImportEdit]
(
@BookingDate DateTime, @VesselOrderNo decimal, @VesselName nvarchar(50), @VoyageNo nvarchar(20), @ETD DateTime, @CutOff datetime, @OnBoard datetime, @ETA datetime, @DateUpdate datetime, @UpdateBy nvarchar(10), @VesselBookingNo nvarchar(20),@Carrier nvarchar(50), @DestPort nvarchar(30),@VoyageNoLima nvarchar(20),
@MBLNo nvarchar(50)
)
AS
SET DATEFORMAT DMY;
UPDATE
VesselRegistryImport
SET
VesselName=@VesselName,
VoyageNo=@VoyageNo,
ETD=@ETD,
CutOff=@CutOff,
OnBoard=@OnBoard,
ETA=@ETA,
VesselBookingNo=@VesselBookingNo,
Carrier=@Carrier,
DestPort=@DestPort,
VoyageNoLima=@VoyageNoLima,
MBLNo=@MBLNo,
DateUpdate=GETDATE(),
UpdateBy=@UpdateBy
where
BookingDate=@BookingDate and VesselOrderNo=@VesselOrderNo



GO
/****** Object:  StoredProcedure [dbo].[VesselRegistryImportLastCntrNoAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create  Procedure [dbo].[VesselRegistryImportLastCntrNoAdd]
(
@BookingDate DateTime, @VesselOrderNo Decimal, @LastContainerOrderNo decimal
)
AS
SET DATEFORMAT DMY;
UPDATE 
VesselRegistryImport
SET
LastContainerOrderNo=@LastContainerOrderNo
Where
BookingDate=@BookingDate and VesselOrderNo=@VesselOrderNo





GO
/****** Object:  StoredProcedure [dbo].[VesselRegistryLastCntrNoAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create   Procedure [dbo].[VesselRegistryLastCntrNoAdd]
(
@BookingDate DateTime, @VesselOrderNo Decimal, @LastContainerOrderNo decimal
)
AS
SET DATEFORMAT DMY;
UPDATE 
VesselRegistry
SET
LastContainerOrderNo=@LastContainerOrderNo
Where
BookingDate=@BookingDate and VesselOrderNo=@VesselOrderNo





GO
/****** Object:  StoredProcedure [dbo].[VesselRegistryRatesAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   Procedure [dbo].[VesselRegistryRatesAdd]
(
@BookingDate DateTime, @VesselOrderNo decimal, @Stuffing40_CBM money, @Stuffing20_CBM money, @BLFee_BL money, @Rigging_Bar money, @Hanging_Bar money, @Partion_Cntr money, @MgmtFee_20 money, @MgmtFee_40 money, @RateEnterBy nvarchar(10), @RateEnterTime datetime

)
AS
SET DATEFORMAT DMY;
UPDATE
VesselRegistry
SET
Stuffing40_CBM=@Stuffing40_CBM, 
Stuffing20_CBM=@Stuffing20_CBM, 
BLFee_BL=@BLFee_BL, 
Rigging_Bar=@Rigging_Bar, 
Hanging_Bar=@Hanging_Bar, 
Partion_Cntr=@Partion_Cntr, 
MgmtFee_20=@MgmtFee_20, 
MgmtFee_40=@MgmtFee_40, 
RateEnterBy=@RateEnterBy, 
RateEnterTime=@RateEnterTime
where
BookingDate=@BookingDate and VesselOrderNo=@VesselOrderNo


GO
/****** Object:  StoredProcedure [dbo].[VesselRegistryReachedDest]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[VesselRegistryReachedDest]
(
@BookingDate DateTime, @VesselOrderNo decimal, @ETA DateTime,@DestReachBy nvarchar(10)

)
AS
SET DATEFORMAT DMY;
UPDATE
VesselRegistry
SET

ETA=@ETA,
DestReachStatus='Update',
DestReachBy=@DestReachBy,
DestReachTime=getdate()
where
BookingDate=@BookingDate and VesselOrderNo=@VesselOrderNo


Update CargoReceived
set
ReachedDest=1
where
BookingDate=@BookingDate and VesselOrderNo=@VesselOrderNo
GO
/****** Object:  StoredProcedure [dbo].[VesselRegistrySFOSJobAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create   Procedure [dbo].[VesselRegistrySFOSJobAdd]
(
@BookingDate DateTime, @VesselOrderNo decimal, @SFOSJobNo nvarchar(10), @SFOSJobNoEnterTime datetime, @SFOSJobNoEnterBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE
VesselRegistry
SET
SFOSJobNo=@SFOSJobNo,
SFOSJobNoEnterBy=@SFOSJobNoEnterBy,
SFOSJobNoEnterTime=@SFOSJobNoEnterTime
where
BookingDate=@BookingDate and VesselOrderNo=@VesselOrderNo


GO
/****** Object:  StoredProcedure [dbo].[VesselRegistrySFOSJobConfirm]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   Procedure [dbo].[VesselRegistrySFOSJobConfirm]
(
@BookingDate DateTime, @VesselOrderNo decimal, @SFOSJobConfirm bit, @SFOSJobConfirmTime datetime, @SFOSJobConfirmBy nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE
VesselRegistry
SET
SFOSJobConfirm=@SFOSJobConfirm,
SFOSJobConfirmBy=@SFOSJobConfirmBy,
SFOSJobConfirmTime=@SFOSJobConfirmTime
where
BookingDate=@BookingDate and VesselOrderNo=@VesselOrderNo


GO
/****** Object:  StoredProcedure [dbo].[WACargoBarcodeAirSeaLoad]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[WACargoBarcodeAirSeaLoad]
(
@RcvNo nvarchar(10),@BarCode nvarchar(40),@RemoveDoneDate datetime
)
AS
SET DATEFORMAT DMY;
UPDATE CargoBarCode
set
Status='Upload',
LoadTime=@RemoveDoneDate
where
RcvNo=@RcvNo and BarCode=@BarCode
GO
/****** Object:  StoredProcedure [dbo].[WACargoBarcodeAirSeaLoadPallet]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[WACargoBarcodeAirSeaLoadPallet]
(
    @BookingDate DATETIME,
	@VesselOrderNo decimal(18,0),
	@ContainerOrderNo decimal(18,0),
	@RcvNo NVARCHAR(10),
	@DepartmentCode NVARCHAR(20),
	@BoxId int,
	@ItemOption NVARCHAR(50),
	@PalletNo decimal(18,0),
	@RemoveDoneBy nvarchar(10),
    @RemoveDoneDate DATETIME,
	@isNewPallet BIT,
    @IsPalletClosed BIT
)
AS
BEGIN
    SET DATEFORMAT DMY;
	--Update Cargo Barcode
    UPDATE CargoBarCode
    SET
        Status = 'Upload',
        LoadTime = @RemoveDoneDate,
		ExportPalletNo=@PalletNo
    WHERE
        RcvNo = @RcvNo 
        AND LPNBoxNo = @BoxId;

	--Update Cargo Manual Box	
    UPDATE CargoManualBox
    SET
        Status = 'Upload',
		ExportPalletNo=@PalletNo
    WHERE
        RcvNo = @RcvNo 
        AND LPNBoxNo = @BoxId;

	--Update Cargo Recived
	UPDATE  CargoReceived
	SET
	RemoveQty=RemoveQty+1,
	RemoveDoneDate=@RemoveDoneDate,
	RemoveDoneBy=@RemoveDoneBy
	where
	RcvNo=@RcvNo
	

	--Update Container Data (Conditional based on @isNewPallet)
	IF @isNewPallet = 1 -- Only execute if a new pallet is being created/used
	BEGIN
		UPDATE  ContainerData
		SET
		LastPalletNo=@PalletNo
		where
		BookingDate=@BookingDate  and
		VesselOrderNo=@VesselOrderNo  and 
		ContainerOrderNo=@ContainerOrderNo
	END



	--Insert CargoPalletLoading
	IF EXISTS (
            SELECT 1 FROM CargoPalletLoading
            WHERE
                BookingDate = @BookingDate
                AND VesselOrderNo = @VesselOrderNo
                AND ContainerOrderNo = @ContainerOrderNo
                AND PalletNo = @PalletNo
        )
        BEGIN
            -- record exists -> update
            UPDATE CargoPalletLoading
            SET
                IsClosed = @IsPalletClosed,
                LastModifiedDate = GETDATE()
            WHERE
                BookingDate = @BookingDate
                AND VesselOrderNo = @VesselOrderNo
                AND ContainerOrderNo = @ContainerOrderNo
                AND PalletNo = @PalletNo;
        END
        ELSE
        BEGIN
            -- record not found -> insert
            INSERT INTO CargoPalletLoading
            (
                BookingDate,
                VesselOrderNo,
                ContainerOrderNo,
                PalletNo,
                IsClosed,
                OpenDate,
                LastModifiedDate
            )
            VALUES
            (
                @BookingDate,
                @VesselOrderNo,
                @ContainerOrderNo,
                @PalletNo,
                @IsPalletClosed,
                GETDATE(),
                GETDATE()
            );
        END


END
GO
/****** Object:  StoredProcedure [dbo].[WACargoBarcodeAirSeaLoadStore]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[WACargoBarcodeAirSeaLoadStore]
(
@RcvNo nvarchar(10),@BarCode nvarchar(40),@RemoveDoneDate datetime
)
AS
SET DATEFORMAT DMY;
UPDATE CargoBarcodeCtnOut
set
Status='Upload',
LoadTime=@RemoveDoneDate
where
RcvNo+BoxId= @BarCode
GO
/****** Object:  StoredProcedure [dbo].[WACargoBarCodeUnloadAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[WACargoBarCodeUnloadAdd](
    @RcvNo nvarchar(10),
    @BarCode nvarchar(40), 
    @PalletOrderNo decimal, 
    @ILSMismatch varchar(5)
)
AS
BEGIN
    SET DATEFORMAT DMY;

    -- Check if the record already exists
    IF NOT EXISTS (
        SELECT 1 
        FROM CargoBarCode 
        WHERE RcvNo = @RcvNo 
          AND BarCode = @BarCode
    )
    BEGIN
        -- If the record does not exist, perform the insert
        INSERT INTO CargoBarCode
        (RcvNo, BarCode, ItemOption, PalletOrderNo, ILSMismatch)
        VALUES
        (@RcvNo, @BarCode, LEFT(@BarCode, 8), @PalletOrderNo, @ILSMismatch);
    END
   
END
GO
/****** Object:  StoredProcedure [dbo].[WACargoPalletsUnloadAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[WACargoPalletsUnloadAdd]
(
@RcvNo nvarchar(10), @PalletOrderNo decimal, @PalletType nvarchar(10), @PalletNo nvarchar(50), @UnitsLoad  decimal, @PalletLocation nvarchar(50), @PalletQC bit
)
AS
SET DATEFORMAT DMY
INSERT INTO CargoPallets
(RcvNo, PalletOrderNo, PalletType, PalletNo, UnitsLoad, PalletLocation, PalletQC)
values
(@RcvNo, @PalletOrderNo, @PalletType, @PalletNo, @UnitsLoad, @PalletLocation, @PalletQC)



GO
/****** Object:  StoredProcedure [dbo].[WACargoPalletsUnloadEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[WACargoPalletsUnloadEdit]
(
@RcvNo nvarchar(10), @PalletOrderNo decimal, @PalletType nvarchar(10), @PalletNo nvarchar(50), @UnitsLoad  decimal, @PalletLocation nvarchar(50), @PalletQC bit
)
AS
SET DATEFORMAT DMY
update CargoPallets
set
UnitsLoad=@UnitsLoad
where
RcvNo=@RcvNo and PalletOrderNo=@PalletOrderNo
GO
/****** Object:  StoredProcedure [dbo].[WACargoReceivedAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE      procedure [dbo].[WACargoReceivedAdd]
(
@RcvNo nvarchar(10), @RcvDate nvarchar(20), @RcvTime nvarchar(20),@LorryNo nvarchar(50), @ShipperCode nvarchar(5), @ContractNo nvarchar(50), @ItemNo nvarchar(50), @InvoiceNo nvarchar(50), @PONo nvarchar(50), @DeliveryNo decimal, @ShippingMode nvarchar(10), @CargoType nvarchar(10), @Ctns decimal , @Pcs decimal,  @QCType nvarchar(10), @EnterBy nvarchar(5), @CBM money, @TradeLane nvarchar(10), @Country nvarchar(10),@QCYes nvarchar(10), @PackListYes nvarchar(10),@CDNYes nvarchar(10),@CusDecYes nvarchar(10),@LorryContactName nvarchar(50),@LorryContactNo nvarchar(50)
)
AS
SET Dateformat DMY;
Insert Into
CargoReceived
(RcvNo , IntakeTime, IntakeTimeSys,LorryNo, ShipperCode, ContractNo, ItemNo , InvoiceNo, PONo , DeliveryNo, ShippingMode, CargoType , Ctns , Pcs ,  QCType , EnterBy,ShippingModeIn,CBM,CtnsIn , PcsIn ,CBMIn,DeliveryNoIn,TradeLane, Country,TradeLaneIn, CountryIn,QCYes,PackListYes,CDNYes,CusDecYes,IntakeStatus,IntakeStatusBy,LorryContactName,LorryContactNo)
Values
(@RcvNo , @RcvTime, getdate(),@LorryNo, @ShipperCode, @ContractNo, @ItemNo , @InvoiceNo, @PONo , @DeliveryNo, @ShippingMode, @CargoType , @Ctns , @Pcs , @QCType ,@Enterby,@ShippingMode,@CBM,@Ctns , @Pcs ,@CBM,@DeliveryNo,@TradeLane, @Country,@TradeLane, @Country,@QCYes,@PackListYes,@CDNYes,@CusDecYes,'Update',@EnterBy,@LorryContactName,@LorryContactNo)

if @CusDecYes='Yes'
begin
Update CargoReceived SET
Verification=1,
VerificationDate=getdate(),
VerificationBy=@EnterBy
where RcvNo=@RcvNo
end










GO
/****** Object:  StoredProcedure [dbo].[WACargoReceivedAirPickAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[WACargoReceivedAirPickAdd]
(
@RcvNo nvarchar(10),@LorryNoLoad nvarchar(50),@RemovalComments nvarchar(200),@RemoveQty decimal,@RemoveDoneDate datetime,@RemoveDoneBy nvarchar(10),@RemoveType nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE  CargoReceived
SET
LorryNoLoad=@LorryNoLoad,
RemovalComments=@RemovalComments,
RemoveQty=@RemoveQty,
RemoveDoneDate=@RemoveDoneDate,
RemoveDoneBy=@RemoveDoneBy,
RemoveType=@RemoveType
where
RcvNo=@RcvNo


UPDATE CargoBarCode
set
Status='Upload',
LoadTime=@RemoveDoneDate
where
RcvNo=@RcvNo


GO
/****** Object:  StoredProcedure [dbo].[WACargoReceivedAirSeaLoad]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[WACargoReceivedAirSeaLoad]
(
@RcvNo nvarchar(10),@LorryNoLoad nvarchar(50),@RemovalComments nvarchar(200),@RemoveQty decimal,@RemoveDoneDate datetime,@RemoveDoneBy nvarchar(10),@RemoveType nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE  CargoReceived
SET
LorryNoLoad=@LorryNoLoad,
RemovalComments=@RemovalComments,
RemoveQty=@RemoveQty,
RemoveDoneDate=@RemoveDoneDate,
RemoveDoneBy=@RemoveDoneBy,
RemoveType=@RemoveType
where
RcvNo=@RcvNo
GO
/****** Object:  StoredProcedure [dbo].[WACargoReceivedAirSeaLoadStore]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[WACargoReceivedAirSeaLoadStore]
(
@RcvNo nvarchar(10),@LorryNoLoad nvarchar(50),@RemovalComments nvarchar(200),@RemoveQty decimal,@RemoveDoneDate datetime,@RemoveDoneBy nvarchar(10),@RemoveType nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE  CargoReceived
SET
LorryNoLoad=@LorryNoLoad,
RemovalComments=@RemovalComments,
RemoveQty=RemoveQty+@RemoveQty,
RemoveDoneDate=@RemoveDoneDate,
RemoveDoneBy=@RemoveDoneBy,
RemoveType=@RemoveType
where
RcvNo=@RcvNo
GO
/****** Object:  StoredProcedure [dbo].[WACargoReceivedEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE    procedure [dbo].[WACargoReceivedEdit]
(
@RcvNo nvarchar(10), @RcvDate nvarchar(20), @RcvTime nvarchar(20),@LorryNo nvarchar(50), @ShipperCode nvarchar(5), @ContractNo nvarchar(50), @ItemNo nvarchar(50), @InvoiceNo nvarchar(50), @PONo nvarchar(50), @DeliveryNo decimal, @ShippingMode nvarchar(10), @CargoType nvarchar(10), @Ctns decimal , @Pcs decimal,  @QCType nvarchar(10), @EnterBy nvarchar(5), @CBM money, @TradeLane nvarchar(10), @Country nvarchar(10),@QCYes nvarchar(10), @PackListYes nvarchar(10),@CDNYes nvarchar(10),@CusDecYes nvarchar(10), @LorryContactName nvarchar(50),@LorryContactNo nvarchar(50)
)
AS
SET Dateformat DMY;
Update
CargoReceived
SET

IntakeTimeSys=getdate(), 
LorryNo=@LorryNo, 
ShipperCode=@ShipperCode, 
ContractNo=@ContractNo, 
ItemNo=@ItemNo , 
InvoiceNo=@InvoiceNo, 
PONo='' , 
DeliveryNo=@DeliveryNo, 
ShippingMode=@ShippingMode, 
CargoType=@CargoType , 
Ctns=@Ctns , 
Pcs=@Pcs , 
 QCType=@QCType , 
 UpdateBy=@EnterBy,
 ShippingModeIn=@ShippingMode,
 CBM=@CBM,
 CtnsIn=@Ctns , 
 PcsIn=@Pcs ,
 CBMIn=@CBM,
 DeliveryNoIn=@DeliveryNo,
 TradeLane=@TradeLane, 
 Country=@Country,
 TradeLaneIn=@TradeLane, 
 CountryIn=@Country,
 QCYes=@QCYes,
 PackListYes=@PackListYes,
 CDNYes=@CDNYes,
 CusDecYes=@CusDecYes,
 IntakeStatus='Updat',
 IntakeStatusBy=@EnterBy,
 IntakeTime=@RcvTime,
 LorryContactName=@LorryContactName,
 LorryContactNo=@LorryContactNo
 where

RcvNo=@RcvNo

if @CusDecYes='Yes'
begin
Update CargoReceived SET
Verification=1,
VerificationDate=getdate(),
VerificationBy=@EnterBy
where RcvNo=@RcvNo
end
else
begin
Update CargoReceived SET
Verification=0,
VerificationDate=null,
VerificationBy=''
where RcvNo=@RcvNo
end











GO
/****** Object:  StoredProcedure [dbo].[WACargoReceivedUnloadAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[WACargoReceivedUnloadAdd](
@RcvNo nvarchar(10),@EntryType nvarchar(10),@RcvDate datetime,@RcvTime datetime,@ScanQty decimal,@InQty decimal,@UnloadStatus nvarchar(10),@UnloadBy nvarchar(10),@IntakeComments nvarchar(200),@CargoQuality nvarchar(15)
)

AS
BEGIN 
	SET DATEFORMAT DMY;
	Declare @ReworkApply bit;
	-- Now Read ReworkApply From Destwarehouse and assign to @ReworkApply
	SELECT @ReworkApply = DW.ReworkApply
		FROM CargoReceived CR
		INNER JOIN DestWarehouse DW ON DW.WhDes = CR.Warehouse
		WHERE CR.RcvNo = @RcvNo;

	SET DATEFORMAT dmy;
	Update CargoReceived
	SET

	EntryType=@EntryType,
	RcvDate=@RcvDate,
	RcvTime=@RcvTime,
	ScanQty=@ScanQty,
	InQty=@InQty,
	UnloadStatus=@UnloadStatus,
	UnloadBy=@UnloadBy,
	UnloadTimeSys=GETDATE(),
	IntakeComments=@IntakeComments,
	CargoQuality=@CargoQuality,
	ReWorkQty = CASE WHEN @ReworkApply = 0 THEN @InQty ELSE 0 END,
	InPCS = CASE WHEN @ReworkApply = 0 THEN PCS ELSE 0 END,
	PickPackStatus = CASE WHEN @ReworkApply = 0 THEN 'Finish' ELSE '' END,
	PickPackStatusBy = CASE WHEN @ReworkApply = 0 THEN @UnloadBy ELSE '' END,
	PickPackStatusTime = CASE WHEN @ReworkApply = 0 THEN GETDATE() ELSE null END


	where
	RcvNo=@RcvNo

END

GO
/****** Object:  StoredProcedure [dbo].[WAFactorySupervisorAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[WAFactorySupervisorAdd]
(@SupervisorId nvarchar(10), @SupervisorName nvarchar(50), @SupervisorPW nvarchar (10),@EnterBy nvarchar(10))
AS
SET DATEFORMAT DMY;
INSERT INTO FactorySupervisor
(SupervisorId, SupervisorName, SupervisorPW, DateUpdate, EnterBy)
values
(@SupervisorId, @SupervisorName, @SupervisorPW, GETDATE(),@EnterBy)


GO
/****** Object:  StoredProcedure [dbo].[WAFactorySupervisorEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[WAFactorySupervisorEdit]
(@SupervisorId nvarchar(10), @SupervisorName nvarchar(50), @SupervisorPW nvarchar (10))
AS
SET DATEFORMAT DMY;
UPDATE FactorySupervisor
SET
SupervisorName=@SupervisorName, 
SupervisorPW=@SupervisorPW,
DateUpdate=getdate()
where
SupervisorID=@SupervisorId


GO
/****** Object:  StoredProcedure [dbo].[WAPwInfoAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[WAPwInfoAdd]
(
@UserId nvarchar(50), @PassWord nvarchar(50), @Department nchar(1), @UserLevel nvarchar(50), @UserName NVARCHAR(50), @IsNewOption BIT, @IsEditOption BIT, @IsPrintOption BIT, @IsConfirmOption BIT, @IsReConfirmOption BIT, @IsSignOption BIT, @IsCancelOption BIT, @IsOtherOption BIT, @isConfirmAC BIT, @isReEdit BIT, @UserCategory NVARCHAR(15), @EmailAddress NVARCHAR(50),@InitMenuId nvarchar(20), @InitController NVARCHAR(50),@InitAction NVARCHAR(50)
)
AS
SET DATEFORMAT DMY;
INSERT INTO PwInfo 
(UserId, PassWord, Department, Datecreate, UserLevel, UserName,  IsNewOption, IsEditOption, IsPrintOption, IsConfirmOption, IsReConfirmOption, IsSignOption, IsCancelOption, IsOtherOption, isConfirmAC, isReEdit, UserCategory, EmailAddress,InitMenuId,InitController,InitAction)

values
(@UserId, @PassWord, @Department, GETDATE(), @UserLevel, @UserName,  @IsNewOption, @IsEditOption, @IsPrintOption, @IsConfirmOption, @IsReConfirmOption, @IsSignOption, @IsCancelOption, @IsOtherOption, @isConfirmAC, @isReEdit, @UserCategory, @EmailAddress,@InitMenuId,@InitController,@InitAction)


GO
/****** Object:  StoredProcedure [dbo].[WAPwInfoeDIT]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[WAPwInfoeDIT]
(
@UserId nvarchar(50), @PassWord nvarchar(50), @Department nchar(1), @UserLevel nvarchar(50), @UserName NVARCHAR(50), @IsNewOption BIT, @IsEditOption BIT, @IsPrintOption BIT, @IsConfirmOption BIT, @IsReConfirmOption BIT, @IsSignOption BIT, @IsCancelOption BIT, @IsOtherOption BIT, @isConfirmAC BIT, @isReEdit BIT, @UserCategory NVARCHAR(15), @EmailAddress NVARCHAR(50),@InitMenuId nvarchar(20), @InitController NVARCHAR(50),@InitAction NVARCHAR(50)
)
AS
SET DATEFORMAT DMY;
update PwInfo 
set
PassWord=@PassWord, 
Department=@Department, 
UserLevel=@UserLevel, 
UserName=@UserName,  
IsNewOption=@IsNewOption, 
IsEditOption=@IsEditOption, 
IsPrintOption=@IsPrintOption, 
IsConfirmOption=@IsConfirmOption, 
IsReConfirmOption=@IsReConfirmOption, 
IsSignOption=@IsSignOption, 
IsCancelOption=@IsCancelOption, 
IsOtherOption=@IsOtherOption, 
isConfirmAC=@isConfirmAC, 
isReEdit=@isReEdit, 
UserCategory=@UserCategory, 
EmailAddress=@EmailAddress,
InitMenuId=@InitMenuId,
InitController=@InitController,
InitAction=@InitAction
where
UserId=@UserId


GO
/****** Object:  StoredProcedure [dbo].[WarehouseSwap]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[WarehouseSwap]
    @ContractNo NVARCHAR(50),
    @DeliveryNo DECIMAL(18, 0),
    @WarehouseIn NVARCHAR(50),
    @Warehouse NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE CargoReceived
    SET WarehouseIn = @WarehouseIn,
        Warehouse = @Warehouse,
		BookingDate = null, 
		ContainerOrderNo=0,
		RemoveStatus='',
		VesselOrderNo=0,
		ApprvReqStatus='', 
		ApprvReqTime=null, 
		ApprvReqBy='', 
		ApprvToShip='', 
		ApprvToShipBy='', 
		ApprvToShipTime=null, 
		nApprvToShip='', 
		nApprvToShipBy='', 
		nApprvToShipTime=null,
		nApprvToShipAction='', 
		nApprvToShipActionTime=null, 
		nApprvToShipActionBy='',
		Authorized=0, 
		AuthDate=null, 
		AuthTime=null
    WHERE ContractNo = @ContractNo
    AND DeliveryNo = @DeliveryNo;
END
GO
/****** Object:  StoredProcedure [dbo].[WSCargoBarCodeUploadAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE   procedure [dbo].[WSCargoBarCodeUploadAdd]
(@BarCode nvarchar(400), @Status nvarchar(10), @UpNo nvarchar(10)
)
AS
SET DATEFORMAT DMY;
UPDATE CargoBarCode
set 
Status=@Status,
UpNo=@UpNo
where
BarCode=@BarCode
and Status=''






GO
/****** Object:  StoredProcedure [dbo].[WSCargoReceivedAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE        procedure [dbo].[WSCargoReceivedAdd]
(
@RcvNo nvarchar(10), @RcvDate datetime, @RcvTime datetime, @ShipperCode nvarchar(5), @ContractNo nvarchar(50), @ItemNo nvarchar(50), @InvoiceNo nvarchar(50), @PONo nvarchar(50), @DeliveryNo decimal, @ShippingMode nvarchar(10), @CargoType nvarchar(10), @Ctns decimal , @Pcs decimal, @LorryNo nvarchar(50), @QCType nvarchar(10), @EnterBy nvarchar(5), @CBM money, @TradeLane nvarchar(10), @Country nvarchar(10),@ScanQty decimal
)
AS
SET Dateformat DMY;
Insert Into
CargoReceived
(RcvNo , RcvDate, RcvTime, ShipperCode, ContractNo, ItemNo , InvoiceNo, PONo , DeliveryNo, ShippingMode, CargoType , Ctns , Pcs , LorryNo , QCType , EnterBy,ShippingModeIn,CBM,CtnsIn , PcsIn ,CBMIn,DeliveryNoIn,TradeLane, Country,TradeLaneIn, CountryIn,ScanQty,InQty,EntryType,IntakeStatus,IntakeStatusBy,IntakeTime,IntakeTimeSys,UnloadStatus,UnloadBy,UnloadTimeSys)
Values
(@RcvNo , @RcvDate, @RcvTime, @ShipperCode, @ContractNo, @ItemNo , @InvoiceNo, @PONo , @DeliveryNo, @ShippingMode, @CargoType , @Ctns , @Pcs , @LorryNo , @QCType ,@Enterby,@ShippingMode,@CBM,@Ctns , @Pcs ,@CBM,@DeliveryNo,@TradeLane, @Country,@TradeLane, @Country, @ScanQty,@ScanQty,'Scan','Update',@EnterBy,@RcvTime,@RcvTime,'Update',@EnterBy,@RcvTime)











GO
/****** Object:  StoredProcedure [dbo].[WSCargoReceivedCntrLoad]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create  procedure [dbo].[WSCargoReceivedCntrLoad]
(
@RcvNo nvarchar(10), @RemoveQty decimal
)
as
SET DATEFORMAT DMY;
UPDATE CargoReceived
SET
RemoveQty=RemoveQty+@RemoveQty
Where
RcvNo=@RcvNo





GO
/****** Object:  StoredProcedure [dbo].[WSCargoReceivedEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE        procedure [dbo].[WSCargoReceivedEdit]
(
@RcvNo nvarchar(10), @ScanQty decimal
)
AS
SET Dateformat DMY;
UPDATE CargoReceived
SET
ScanQty=ScanQty+@ScanQty,
Inqty=Inqty+ @ScanQty
Where
RcvNo=@RcvNo











GO
/****** Object:  StoredProcedure [dbo].[WSCargoReceivedLoadQtyAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure 
[dbo].[WSCargoReceivedLoadQtyAdd]
(
@RcvNo nvarchar(10), @RemoveDoneDate datetime, @RemoveDoneBy nvarchar(10),@RemoveType nvarchar(10), @RemovalComments nvarchar(200), @RemoveQty decimal
)
AS
SET DATEFORMAT DMY;
UPDATE CargoReceived
set
RemoveDoneDate=@RemoveDoneDate,
RemoveDoneBy=@RemoveDoneBy,
RemoveType=@RemoveType,
RemovalComments=@RemovalComments,
RemoveQty=RemoveQty+@RemoveQty
where
Rcvno=@RcvNo


GO
/****** Object:  StoredProcedure [dbo].[WSCargoReceivedRejectQtyAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure 
[dbo].[WSCargoReceivedRejectQtyAdd]
(
@RcvNo nvarchar(10), @RemoveDoneDate datetime, @RemoveDoneBy nvarchar(10),@RemoveType nvarchar(10), @RemoveQty decimal
)
AS
SET DATEFORMAT DMY;
UPDATE CargoReceived
set
RemoveDoneDate=@RemoveDoneDate,
RemoveDoneBy=@RemoveDoneBy,
RemoveType=@RemoveType,
RemoveQty=RemoveQty+@RemoveQty
where
Rcvno=@RcvNo


GO
/****** Object:  StoredProcedure [dbo].[WSCargoReceivedReworkRemoveScan]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create  procedure [dbo].[WSCargoReceivedReworkRemoveScan]
(
@RcvNo nvarchar(10), @RemoveQtyPartScan decimal
)
as
SET DATEFORMAT DMY;
UPDATE CargoReceived
SET
RemoveQtyPartScan=RemoveQtyPartScan+@RemoveQtyPartScan,
ScanQty=ScanQty+@RemoveQtyPartScan
Where
RcvNo=@RcvNo





GO
/****** Object:  StoredProcedure [dbo].[WSCargoUploadAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE    procedure [dbo].[WSCargoUploadAdd]
(
@UpdNo nvarchar(10),@UpdDate datetime, @LoadRef nvarchar(10),@Loadby nvarchar(10), @LorryNo nvarchar(50),@ShipperCode nvarchar(10)
)
AS
SET dateformat dmy;
Insert Into
CargoUpload
(UpdNo, UpdDate,LoadRef,LoadBy,LorryNo, ShipperCode)
Values(@UpdNo, @UpdDate,@LoadRef,@LoadBy, @LorryNo,@ShipperCode)









GO
/****** Object:  StoredProcedure [dbo].[WSCargoUploadEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE    procedure [dbo].[WSCargoUploadEdit]
(
@UpdNo nvarchar(10),@LorryNo nvarchar(50), @ShipperCode nvarchar(10)
)
AS
SET dateformat dmy;
Update
CargoUpload
SET
LorryNo=@LorryNo,
ShipperCode=@ShipperCode
where 
UpdNo=@UpdNo









GO
/****** Object:  StoredProcedure [dbo].[WSCargoUploadLoadQtyAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure 
[dbo].[WSCargoUploadLoadQtyAdd]
(

@UpdNo NVARCHAR(10), @LoadFinish bit
)
as
SET DATEFORMAT DMY;
UPDATE CargoUpload
SET
LoadFinish=@LoadFinish
where
UpdNo=@UpdNo


GO
/****** Object:  StoredProcedure [dbo].[WSCargoUploadRcvNoAdd]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





create   procedure [dbo].[WSCargoUploadRcvNoAdd]
(
@UpdNo nvarchar(10), @OrderNo decimal, @RcvNo nvarchar(10), @LoadQty decimal
)
AS
SET dateformat dmy;
INSERT INTO
CargoUploadRcvNo
(UpdNo, RcvNo, OrderNo, LoadQty)
Values
(@UpdNo, @RcvNo, @OrderNo, @LoadQty)








GO
/****** Object:  StoredProcedure [dbo].[WSCargoUploadRcvNoEdit]    Script Date: 10/18/2026 10:38:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





create    procedure [dbo].[WSCargoUploadRcvNoEdit]
(
@UpdNo nvarchar(10),@RcvNo nvarchar(10), @LoadQty decimal
)
AS
SET dateformat dmy;
UPDATE
CargoUploadRcvNo
SET
LoadQty=LoadQty+@LoadQty
where
UpdNo=@UpdNo and RcvNo=@RcvNo 








GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'''B'' BoxEAN, ''R'' RFIDEAN, ''E'' EAN Label' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CargoBarcodeFirewallErrors', @level2type=N'COLUMN',@level2name=N'ErrorType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'''''' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CargoReceived', @level2type=N'COLUMN',@level2name=N'QCType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'List-Contract/ContractDelivery' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CompanySetup', @level2type=N'COLUMN',@level2name=N'CheckDuplicate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'List-Zero/NonZero' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CompanySetup', @level2type=N'COLUMN',@level2name=N'Delivery'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1-Only4CheckDuplicate=''ContractDelivery'' and Delivery=''Zero''' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CompanySetup', @level2type=N'COLUMN',@level2name=N'DeliveryAutoAdd'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Type 1 =crENABarcodeCode128JoJo.rpt , Type 2 = crENABarcodeCode128.rpt' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DestWarehouse', @level2type=N'COLUMN',@level2name=N'EanLblType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sum/Ind' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RateCFSExport', @level2type=N'COLUMN',@level2name=N'UnitCalType'
GO
