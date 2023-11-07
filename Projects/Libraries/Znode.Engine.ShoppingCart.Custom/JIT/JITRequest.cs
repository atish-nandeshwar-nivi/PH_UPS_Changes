using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Znode.Engine.Shipping.Custom
{


    // NOTE: Generated code may require at least .NET Framework 4.5 or .NET Core/Standard 2.0.
    /// <remarks/>
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://tempuri.org/")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "http://tempuri.org/", IsNullable = false)]
    public partial class Quote
    {

        private QuoteElemRequest elemRequestField;

        /// <remarks/>
        public QuoteElemRequest elemRequest
        {
            get
            {
                return this.elemRequestField;
            }
            set
            {
                this.elemRequestField = value;
            }
        }
    }

    /// <remarks/>
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://tempuri.org/")]
    public partial class QuoteElemRequest
    {

        private TPWQuoteRequest tPWField;

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Namespace = "")]
        public TPWQuoteRequest TPW
        {
            get
            {
                return this.tPWField;
            }
            set
            {
                this.tPWField = value;
            }
        }
    }

    /// <remarks/>
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false)]
    public partial class TPWQuoteRequest
    {

        private TPWRequest requestField;

        /// <remarks/>
        public TPWRequest Request
        {
            get
            {
                return this.requestField;
            }
            set
            {
                this.requestField = value;
            }
        }
    }

    /// <remarks/>
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
    public partial class TPWRequest
    {

        private string requestTypeField;

        private TPWRequestCredentials credentialsField;

        private TPWRequestOrder orderField;

        /// <remarks/>
        public string RequestType
        {
            get
            {
                return this.requestTypeField;
            }
            set
            {
                this.requestTypeField = value;
            }
        }

        /// <remarks/>
        public TPWRequestCredentials Credentials
        {
            get
            {
                return this.credentialsField;
            }
            set
            {
                this.credentialsField = value;
            }
        }

        /// <remarks/>
        public TPWRequestOrder Order
        {
            get
            {
                return this.orderField;
            }
            set
            {
                this.orderField = value;
            }
        }
    }

    /// <remarks/>
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
    public partial class TPWRequestCredentials
    {

        private string userKeyField;

        private string userNameField;

        private string passwordField;

        /// <remarks/>
        public string UserKey
        {
            get
            {
                return this.userKeyField;
            }
            set
            {
                this.userKeyField = value;
            }
        }

        /// <remarks/>
        public string UserName
        {
            get
            {
                return this.userNameField;
            }
            set
            {
                this.userNameField = value;
            }
        }

        /// <remarks/>
        public string Password
        {
            get
            {
                return this.passwordField;
            }
            set
            {
                this.passwordField = value;
            }
        }
    }

    /// <remarks/>
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
    public partial class TPWRequestOrder
    {

        private TPWRequestOrderOptimism optimismField;

        private TPWRequestOrderShipping shippingField;

        private TPWRequestOrderItem[] itemField;

        /// <remarks/>
        public TPWRequestOrderOptimism Optimism
        {
            get
            {
                return this.optimismField;
            }
            set
            {
                this.optimismField = value;
            }
        }

        /// <remarks/>
        public TPWRequestOrderShipping Shipping
        {
            get
            {
                return this.shippingField;
            }
            set
            {
                this.shippingField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("Item")]
        public TPWRequestOrderItem[] Item
        {
            get
            {
                return this.itemField;
            }
            set
            {
                this.itemField = value;
            }
        }
    }

    /// <remarks/>
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
    public partial class TPWRequestOrderOptimism
    {

        private string allowDuplicatePOField;

        /// <remarks/>
        public string AllowDuplicatePO
        {
            get
            {
                return this.allowDuplicatePOField;
            }
            set
            {
                this.allowDuplicatePOField = value;
            }
        }
    }

    /// <remarks/>
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
    public partial class TPWRequestOrderShipping
    {

        private string firstNameField;

        private string lastNameField;

        private string companyField;

        private string address1Field;

        private object address2Field;

        private string cityField;

        private string stateField;

        private string zipField;

        private string countryField;

        private string phoneField;

        private string receivingHoursField;

        /// <remarks/>
        public string FirstName
        {
            get
            {
                return this.firstNameField;
            }
            set
            {
                this.firstNameField = value;
            }
        }

        /// <remarks/>
        public string LastName
        {
            get
            {
                return this.lastNameField;
            }
            set
            {
                this.lastNameField = value;
            }
        }

        /// <remarks/>
        public string Company
        {
            get
            {
                return this.companyField;
            }
            set
            {
                this.companyField = value;
            }
        }

        /// <remarks/>
        public string Address1
        {
            get
            {
                return this.address1Field;
            }
            set
            {
                this.address1Field = value;
            }
        }

        /// <remarks/>
        public object Address2
        {
            get
            {
                return this.address2Field;
            }
            set
            {
                this.address2Field = value;
            }
        }

        /// <remarks/>
        public string City
        {
            get
            {
                return this.cityField;
            }
            set
            {
                this.cityField = value;
            }
        }

        /// <remarks/>
        public string State
        {
            get
            {
                return this.stateField;
            }
            set
            {
                this.stateField = value;
            }
        }

        /// <remarks/>
        public string Zip
        {
            get
            {
                return this.zipField;
            }
            set
            {
                this.zipField = value;
            }
        }

        /// <remarks/>
        public string Country
        {
            get
            {
                return this.countryField;
            }
            set
            {
                this.countryField = value;
            }
        }

        /// <remarks/>
        public string Phone
        {
            get
            {
                return this.phoneField;
            }
            set
            {
                this.phoneField = value;
            }
        }

        /// <remarks/>
        public string ReceivingHours
        {
            get
            {
                return this.receivingHoursField;
            }
            set
            {
                this.receivingHoursField = value;
            }
        }
    }

    /// <remarks/>
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
    public partial class TPWRequestOrderItem
    {

        private string sKUField;

        private int quantityField;

        /// <remarks/>
        public string SKU
        {
            get
            {
                return this.sKUField;
            }
            set
            {
                this.sKUField = value;
            }
        }

        /// <remarks/>
        public int Quantity
        {
            get
            {
                return this.quantityField;
            }
            set
            {
                this.quantityField = value;
            }
        }
    }




}
