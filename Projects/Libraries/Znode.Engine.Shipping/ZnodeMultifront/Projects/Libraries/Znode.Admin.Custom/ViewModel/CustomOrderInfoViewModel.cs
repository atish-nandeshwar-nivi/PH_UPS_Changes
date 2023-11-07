using Znode.Engine.Admin.ViewModels;

namespace Znode.Admin.Custom.ViewModels
{
    public class CustomOrderInfoViewModel : OrderInfoViewModel
    {
        public string WarehouseCode { get; set; }
        public string WarehouseCode2 { get; set; }
        public string WarehouseShipping { get; set; }
        public string WarehouseShipping2 { get; set; }
        public string SpecialPricing { get; set; }

        public CustomOrderInfoViewModel FromOrderInfoViewModel(OrderInfoViewModel orderModel)
        {
            return new CustomOrderInfoViewModel
            {
                OmsOrderDetailId = orderModel.OmsOrderDetailId,
                OmsOrderId = orderModel.OmsOrderId,
                CreatedByName = orderModel.CreatedByName,
                PaymentStatus = orderModel.PaymentStatus,
                PaymentType = orderModel.PaymentType,
                PaymentDisplayName = orderModel.PaymentDisplayName,
                StoreName = orderModel.StoreName,
                OrderNumber = orderModel.OrderNumber,
                OrderStatus = orderModel.OrderStatus,
                OrderDate = orderModel.OrderDate,
                TransactionId = orderModel.TransactionId,
                TrackingNumber = orderModel.TrackingNumber,
                ShippingType = orderModel.ShippingType,
                PurchaseOrderNumber = orderModel.PurchaseOrderNumber,
                userId = orderModel.userId,
                PortalId = orderModel.PortalId,
                CreditCardNumber = orderModel.CreditCardNumber,
                ShippingTypeDescription = orderModel.ShippingTypeDescription,
                PODocumentName = orderModel.PODocumentName,
                OrderDateWithTime = orderModel.OrderDateWithTime,
                ShippingTrackingUrl = orderModel.ShippingTrackingUrl,
                ShippingCode = orderModel.ShippingCode,
                TaxTransactionNumber = orderModel.TaxTransactionNumber,
                AccountNumber = orderModel?.AccountNumber,
                ShippingMethod = orderModel?.ShippingMethod,
                ShippingTypeClassName = orderModel.ShippingTypeClassName,
                ExternalId = orderModel?.ExternalId,
                ShippingId = System.Convert.ToInt16(orderModel?.ShippingId)
            };
        }
    }


}