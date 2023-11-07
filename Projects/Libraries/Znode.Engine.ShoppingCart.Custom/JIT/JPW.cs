using System.Xml.Serialization;

namespace Znode.Engine.Shipping.Custom
{ 

// NOTE: Generated code may require at least .NET Framework 4.5 or .NET Core/Standard 2.0.
/// <remarks/>
[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
[System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false)]
public partial class TPW
{

    private TPWResponse responseField;

    /// <remarks/>
    public TPWResponse Response
    {
        get
        {
            return this.responseField;
        }
        set
        {
            this.responseField = value;
        }
    }
}

/// <remarks/>
[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
public partial class TPWResponse
{

    private string responseTypeField;

    private TPWResponseQuote[] quotesField;

    private string guidField;

    private string quoteTimeField;
    private string errorField;

    private TPWResponseOrder orderField;

    /// <remarks/>
    public string ResponseType
    {
        get
        {
            return this.responseTypeField;
        }
        set
        {
            this.responseTypeField = value;
        }
    }

    /// <remarks/>
    [System.Xml.Serialization.XmlArrayItemAttribute("Quote", IsNullable = false)]
    public TPWResponseQuote[] Quotes
    {
        get
        {
            return this.quotesField;
        }
        set
        {
            this.quotesField = value;
        }
    }

    /// <remarks/>
    public string Guid
    {
        get
        {
            return this.guidField;
        }
        set
        {
            this.guidField = value;
        }
    }

    /// <remarks/>
    public string QuoteTime
    {
        get
        {
            return this.quoteTimeField;
        }
        set
        {
            this.quoteTimeField = value;
        }
    }

        /// <remarks/>
        [XmlElement(ElementName = "ERROR")]
        public string Error
        {
            get
            {
                return this.errorField;
            }
            set
            {
                this.errorField = value;
            }
        }


        /// <remarks/>
        public TPWResponseOrder Order
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
public partial class TPWResponseQuote
{

    private string carrierCodeField;

    private decimal rateField;

    private string serviceField;

    private TPWResponseQuoteOpt[] optsField;

    /// <remarks/>
    public string CarrierCode
    {
        get
        {
            return this.carrierCodeField;
        }
        set
        {
            this.carrierCodeField = value;
        }
    }

    /// <remarks/>
    public decimal Rate
    {
        get
        {
            return this.rateField;
        }
        set
        {
            this.rateField = value;
        }
    }

    /// <remarks/>
    public string Service
    {
        get
        {
            return this.serviceField;
        }
        set
        {
            this.serviceField = value;
        }
    }

    /// <remarks/>
    [System.Xml.Serialization.XmlArrayItemAttribute("Opt", IsNullable = false)]
    public TPWResponseQuoteOpt[] Opts
    {
        get
        {
            return this.optsField;
        }
        set
        {
            this.optsField = value;
        }
    }
}

/// <remarks/>
[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
public partial class TPWResponseQuoteOpt
{

    private string textField;

    private decimal feeField;

    private string tagField;

    /// <remarks/>
    public string Text
    {
        get
        {
            return this.textField;
        }
        set
        {
            this.textField = value;
        }
    }

    /// <remarks/>
    public decimal Fee
    {
        get
        {
            return this.feeField;
        }
        set
        {
            this.feeField = value;
        }
    }

    /// <remarks/>
    public string Tag
    {
        get
        {
            return this.tagField;
        }
        set
        {
            this.tagField = value;
        }
    }
}

/// <remarks/>
[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
public partial class TPWResponseOrder
{

    private decimal subTotalField;

    private decimal taxField;

    private string locationCodeField;

    private TPWResponseOrderShipping shippingField;

    private TPWResponseOrderItem itemField;

    private int orderIdField;

    /// <remarks/>
    public decimal SubTotal
    {
        get
        {
            return this.subTotalField;
        }
        set
        {
            this.subTotalField = value;
        }
    }

    /// <remarks/>
    public decimal Tax
    {
        get
        {
            return this.taxField;
        }
        set
        {
            this.taxField = value;
        }
    }

    /// <remarks/>
    public string LocationCode
    {
        get
        {
            return this.locationCodeField;
        }
        set
        {
            this.locationCodeField = value;
        }
    }

    /// <remarks/>
    public TPWResponseOrderShipping Shipping
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
    public TPWResponseOrderItem Item
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

    /// <remarks/>
    public int OrderId
    {
        get
        {
            return this.orderIdField;
        }
        set
        {
            this.orderIdField = value;
        }
    }
}

/// <remarks/>
[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
public partial class TPWResponseOrderShipping
{

    private string firstNameField;

    private string lastNameField;

    private string companyField;

    private string address1Field;

    private string cityField;

    private string stateField;

    private string countryField;

    private string zipField;

    private string residentialField;

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
    public string Residential
    {
        get
        {
            return this.residentialField;
        }
        set
        {
            this.residentialField = value;
        }
    }
}

/// <remarks/>
[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
public partial class TPWResponseOrderItem
{

    private string sKUField;

    private decimal priceField;

    private int quantityField;

    private decimal extendedField;

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
    public decimal Price
    {
        get
        {
            return this.priceField;
        }
        set
        {
            this.priceField = value;
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

    /// <remarks/>
    public decimal Extended
    {
        get
        {
            return this.extendedField;
        }
        set
        {
            this.extendedField = value;
        }
    }
}

}