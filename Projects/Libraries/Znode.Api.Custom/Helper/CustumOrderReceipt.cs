using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using Znode.Engine.Api.Models;
using Znode.Libraries.Admin;
using Znode.Libraries.ECommerce.ShoppingCart;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.Framework.Business;
using Znode.Libraries.Resources;

namespace Znode.Api.Custom.Helper
{
    class CustumOrderReceipt : ZnodeOrderReceipt
    {
        //to set order details
        public override DataTable SetOrderData(OrderModel Order, string templateCode = "")
        {
            // Create new row
            DataTable orderTable = CreateOrderTable();
            // Create new  for Shipping
            orderTable = CreateShippingTable(orderTable);
            DataRow orderRow = orderTable.NewRow();
            IZnodeOrderHelper orderHelper = GetService<IZnodeOrderHelper>();
            PortalModel portal = orderHelper.GetPortalDetailsByPortalId(Order.PortalId);
            _currencyCode = Order.CurrencyCode;
            _cultureCode = Order.CultureCode;
            // Additional info
            orderRow["SiteName"] = portal?.StoreName ?? ZnodeConfigManager.SiteConfig.StoreName;
            orderRow["StoreLogo"] = orderHelper.SetPortalLogo(Order.PortalId);
            orderRow["ReceiptText"] = string.Empty;
            orderRow["CustomerServiceEmail"] = FormatStringComma(portal?.CustomerServiceEmail) ?? FormatStringComma(ZnodeConfigManager.SiteConfig.CustomerServiceEmail);
            orderRow["CustomerServicePhoneNumber"] = portal?.CustomerServicePhoneNumber.Trim() ?? ZnodeConfigManager.SiteConfig.CustomerServicePhoneNumber.Trim();
            orderRow["FeedBack"] = Order.Custom5;
            orderRow["ShippingName"] = Order?.ShippingTypeName;

            //Payment info
            if (!String.IsNullOrEmpty(Order.PaymentTransactionToken))
            {
                orderRow["CardTransactionID"] = Order.PaymentTransactionToken;
                orderRow["CardTransactionLabel"] = Admin_Resources.LabelTransactionId;
            }

            orderRow["PaymentName"] = Order.PaymentDisplayName;

            if (!String.IsNullOrEmpty(Order.PurchaseOrderNumber))
            {
                orderRow["PONumber"] = Order.PurchaseOrderNumber;
                orderRow["PurchaseNumberLabel"] = Admin_Resources.LabelPurchaseOrderNumber;
            }

            //Customer info
            orderRow["OrderId"] = Order.OrderNumber;
            orderRow["OrderDate"] = Order.OrderDate.ToShortDateString();

            orderRow["BillingAddress"] = Order.BillingAddressHtml;
            orderRow["PromotionCode"] = Order.CouponCode;
            orderRow["JobName"] = Order.JobName;

            orderRow["ShippingAddress"] = GetOrderShippingAddress(Order);

            orderRow["TotalCost"] = GetFormatPriceWithCurrency(Order.Total);

            // Returned total amount
            orderRow["ReturnedTotalCost"] = GetFormatPriceWithCurrency((decimal)Order.ReturnItemList?.Total);
            if (Order.AdditionalInstructions != null)
            {
                orderRow["AdditionalInstructions"] = Order.AdditionalInstructions;
                orderRow["AdditionalInstructLabel"] = Admin_Resources.LabelAdditionalNotes;
            }

            // Additional info for shipping
            orderRow["TrackingNumber"] = !string.IsNullOrEmpty(Order?.TrackingNumber) ? SetTrackingURL(Order) : string.Empty;
            orderRow["BillingFirstName"] = Order?.BillingAddress?.FirstName;
            orderRow["BillingLastName"] = Order?.BillingAddress?.LastName;
            orderRow["LabelInHandDate"] = Api_Resources.LabelInHandDate;
            orderRow["InHandDate"] = Order.InHandDate.HasValue ? Order.InHandDate.Value.ToString(GetStringDateFormat()) : string.Empty;
            orderRow["LabelShippingConstraintsCode"] = Api_Resources.LabelShippingConstraintsCode;
            orderRow["ShippingConstraintCode"] = string.IsNullOrWhiteSpace(Order.ShippingConstraintCode) ? string.Empty : GetEnumDescriptionValue((ShippingConstraintsEnum)Enum.Parse(typeof(ShippingConstraintsEnum), Order.ShippingConstraintCode));

            var shippedLineItemId = Order?.OrderLineItems?.Where(y => y?.OrderLineItemState?.ToLower() == ZnodeOrderStatusEnum.SHIPPED.ToString().ToLower()).Select(x => x.OmsOrderLineItemsId).ToArray();

            if (!string.IsNullOrEmpty(Order?.TrackingNumber))
            {
                //Set tracking number with link to the selected shipping type url
                SetOrderTrackingNumber(Order, orderRow);
                string url = !string.IsNullOrEmpty(SetTrackingURL(Order)) ? SetTrackingURL(Order) : string.Empty;
                orderRow["TrackingMessage"] = Equals(Order.OrderState, ZnodeOrderStatusEnum.SHIPPED.ToString()) ? Admin_Resources.ShippingTrackingNoMessage + url : string.Empty;
                orderRow["Message"] = string.Format(Admin_Resources.ShippingStatusMessage, Order?.OrderState?.ToLower()) + (Equals(Order?.OrderState, ZnodeOrderStatusEnum.SHIPPED.ToString()) ? Admin_Resources.TrackingPackageMessage : string.Empty);
            }
            else if (shippedLineItemId.Any())
            {
                orderRow["TrackingMessage"] = string.Empty;
                orderRow["Message"] = string.Format(Admin_Resources.ShippingStatusMessage, ZnodeOrderStatusEnum.SHIPPED.ToString().ToLower()) + Admin_Resources.TrackingPackageMessage;
            }
            else
            {
                orderRow["TrackingMessage"] = string.Empty;
                orderRow["Message"] = string.Format(Admin_Resources.ShippingStatusMessage, Order?.OrderState?.ToLower());
            }

            // Add rows to order table
            orderTable.Rows.Add(orderRow);
            return orderTable;
        }

        /// <summary>
        /// Get description of the passed Enum field from Enum value
        /// </summary>
        /// <param name="value">Enum</param>
        /// <returns>string</returns>
        public static string GetEnumDescriptionValue(Enum value)
        {
            FieldInfo fieldInfo = value.GetType().GetField(value.ToString(), BindingFlags.Static | BindingFlags.Public);

            DescriptionAttribute[] descriptionAttributes = fieldInfo.GetCustomAttributes(
                typeof(DescriptionAttribute), false) as DescriptionAttribute[];

            if (descriptionAttributes != null && descriptionAttributes.Length > 0)
            {
                return descriptionAttributes[0].Description;
            }

            return fieldInfo.Name.ToString();
        }

    }
}
