using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Znode.Api.Model.Custom.CustomerUserMessageDataModel;
using Znode.Libraries.Data;
using Znode.Libraries.Data.DataModel;
using Znode.Libraries.ECommerce.Utilities;

namespace Znode.Api.Custom.Service.Service
{
    public class PHImportCustomerUserMessageService
    {
        private readonly ZnodeRepository<ZnodeUser> _znodeUser;
        private readonly ZnodeRepository<ZnodeGlobalAttribute> _znodeGlobalAttribute;
        private readonly ZnodeRepository<ZnodeUserGlobalAttributeValue> _znodeUserGlobalAttributeValue;
        private readonly ZnodeRepository<ZnodeUserGlobalAttributeValueLocale> _znodeUserGlobalAttributeValueLocale;

        public PHImportCustomerUserMessageService()
        {
            _znodeUser = new ZnodeRepository<ZnodeUser>();
            _znodeGlobalAttribute = new ZnodeRepository<ZnodeGlobalAttribute>();
            _znodeUserGlobalAttributeValue = new ZnodeRepository<ZnodeUserGlobalAttributeValue>();
            _znodeUserGlobalAttributeValueLocale = new ZnodeRepository<ZnodeUserGlobalAttributeValueLocale>();
        }

        public bool ImportCustomerUserMessage(List<CustomerUserMessageModel> models)
        {
            bool status = false;
            try
            {
                int TotalRowCount = models.Count;
                int SuceessRecords = 0;
                int FailRecords = 0;
                DataTable dt = new DataTable();
                dt.Columns.Add(new DataColumn("UserName"));
                dt.Columns.Add(new DataColumn("ErrorMessage"));
                foreach (CustomerUserMessageModel item in models)
                {
                    DataRow dr = dt.NewRow();
                    try
                    {
                        ZnodeUser znodeUser = _znodeUser.Table.Where(x => x.UserName == item.UserName).FirstOrDefault();
                        if (HelperUtility.IsNull(znodeUser))
                        {
                            FailRecords++;
                            dr["UserName"] = item.UserName;
                            dr["ErrorMessage"] = "User Not Found in DB";
                            dt.Rows.Add(dr);
                        }
                        else
                        {
                            ZnodeGlobalAttribute znodeGlobalAttribute = _znodeGlobalAttribute.Table.Where(y => y.AttributeCode == "UserMessage").FirstOrDefault();
                            if (HelperUtility.IsNull(znodeGlobalAttribute))
                            {
                                FailRecords++;
                                dr["UserName"] = item.UserName;
                                dr["ErrorMessage"] = "AttributeCode UserMessage Not Found in DB";
                                dt.Rows.Add(dr);
                            }
                            else
                            {
                                ZnodeUserGlobalAttributeValue znodeUserGlobalAttributeValue = _znodeUserGlobalAttributeValue.Table.Where(z => z.UserId == znodeUser.UserId && z.GlobalAttributeId == znodeGlobalAttribute.GlobalAttributeId).FirstOrDefault();
                                if (HelperUtility.IsNull(znodeUserGlobalAttributeValue))
                                {
                                    var newznodeUserGlobalAttributeValue = _znodeUserGlobalAttributeValue.Insert(new ZnodeUserGlobalAttributeValue()
                                    {
                                        UserId = znodeUser.UserId,
                                        GlobalAttributeId = znodeGlobalAttribute.GlobalAttributeId,
                                        GlobalAttributeDefaultValueId = null,
                                        AttributeValue = null,
                                        CreatedBy = 2,
                                        CreatedDate = DateTime.Now,
                                        ModifiedBy = 2,
                                        ModifiedDate = DateTime.Now
                                    });
                                    _znodeUserGlobalAttributeValueLocale.Insert(new ZnodeUserGlobalAttributeValueLocale()
                                    {
                                        UserGlobalAttributeValueId = newznodeUserGlobalAttributeValue.UserGlobalAttributeValueId,
                                        LocaleId = 1,
                                        AttributeValue = item.UserMessage,
                                        CreatedBy = 2,
                                        CreatedDate = DateTime.Now,
                                        ModifiedBy = 2,
                                        ModifiedDate = DateTime.Now,
                                        GlobalAttributeDefaultValueId = null,
                                        MediaId = null,
                                        MediaPath = null
                                    });
                                    SuceessRecords++;
                                }
                                else
                                {
                                    znodeUserGlobalAttributeValue.ModifiedBy = 2;
                                    znodeUserGlobalAttributeValue.ModifiedDate = DateTime.Now;
                                    _znodeUserGlobalAttributeValue.Update(znodeUserGlobalAttributeValue);
                                    ZnodeUserGlobalAttributeValueLocale znodeUserGlobalAttributeValueLocale = _znodeUserGlobalAttributeValueLocale.Table.Where(xx => xx.UserGlobalAttributeValueId == znodeUserGlobalAttributeValue.UserGlobalAttributeValueId).FirstOrDefault();
                                    if (HelperUtility.IsNull(znodeUserGlobalAttributeValueLocale))
                                    {
                                        _znodeUserGlobalAttributeValueLocale.Insert(new ZnodeUserGlobalAttributeValueLocale()
                                        {
                                            UserGlobalAttributeValueId = znodeUserGlobalAttributeValue.UserGlobalAttributeValueId,
                                            LocaleId = 1,
                                            AttributeValue = item.UserMessage,
                                            CreatedBy = 2,
                                            CreatedDate = DateTime.Now,
                                            ModifiedBy = 2,
                                            ModifiedDate = DateTime.Now,
                                            GlobalAttributeDefaultValueId = null,
                                            MediaId = null,
                                            MediaPath = null
                                        });
                                        SuceessRecords++;
                                    }
                                    else
                                    {
                                        znodeUserGlobalAttributeValueLocale.AttributeValue = item.UserMessage;
                                        znodeUserGlobalAttributeValueLocale.ModifiedBy = 2;
                                        znodeUserGlobalAttributeValueLocale.ModifiedDate = DateTime.Now;
                                        _znodeUserGlobalAttributeValueLocale.Update(znodeUserGlobalAttributeValueLocale);
                                        SuceessRecords++;
                                    }
                                }
                            }
                        }
                    }
                    catch (Exception Ex)
                    {
                        FailRecords++;
                        dr["UserName"] = item.UserName;
                        dr["ErrorMessage"] = Ex.Message;
                        dt.Rows.Add(dr);
                    }
                }
                status = updateCustomerUserMessageLog(TotalRowCount, SuceessRecords, FailRecords, dt);
                return status;
            }
            catch (Exception)
            {
                status = false;
                return status;
            }
            
        }

        private bool updateCustomerUserMessageLog(int TotalRowCount,int SuceessRecords,int FailRecords,DataTable dt)
        {
            bool status = false;
            string LogStatus = TotalRowCount == SuceessRecords ? "Suceess" : "Fail";
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ZnodeECommerceDB"].ConnectionString))
            {
                try
                {
                    SqlCommand command = new SqlCommand("Nivi_UpdateCustomerUserMessageLogs", connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@TotalRowCount", TotalRowCount);
                    command.Parameters.AddWithValue("@SuceessRecords", SuceessRecords);
                    command.Parameters.AddWithValue("@FailRecords", FailRecords);
                    command.Parameters.AddWithValue("@LogStatus", LogStatus);
                    command.Parameters.AddWithValue("@ErrorDetailsLog", dt);
                    SqlDataReader reader = command.ExecuteReader();

                    connection.Close();
                    status = true;
                    return status;
                }
                catch (Exception ex)
                {
                    status = false;
                    return status;
                }
            }
        }

        public List<CustomerUserMessageLogModel> GetCustomerUserMessageLog()
        {
            List<CustomerUserMessageLogModel> _CustomerUserMessageLogModellist = new List<CustomerUserMessageLogModel>();
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ZnodeECommerceDB"].ConnectionString))
            {
                try
                {
                    SqlCommand command = new SqlCommand("Nivi_GetCustomerUserMessageLogs", connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        CustomerUserMessageLogModel _CustomerUserMessageLogModel = new CustomerUserMessageLogModel();
                        _CustomerUserMessageLogModel.CustomerUserMessageLogId = Convert.ToInt32(reader["CustomerUserMessageLogId"]);
                        _CustomerUserMessageLogModel.Status = reader["Status"].ToString();
                        _CustomerUserMessageLogModel.TotalRecords = Convert.ToInt32(reader["TotalRecords"]);
                        _CustomerUserMessageLogModel.SuceessRecords = Convert.ToInt32(reader["SuceessRecords"]);
                        _CustomerUserMessageLogModel.FailRecords = Convert.ToInt32(reader["FailRecords"]);
                        _CustomerUserMessageLogModel.CreatedBy = Convert.ToInt32(reader["CreatedBy"]);
                        _CustomerUserMessageLogModel.CreatedDate = Convert.ToDateTime(reader["CreatedDate"]);
                        _CustomerUserMessageLogModellist.Add(_CustomerUserMessageLogModel);
                    }
                    connection.Close();
                    return _CustomerUserMessageLogModellist;
                }
                catch (Exception ex)
                {
                    return _CustomerUserMessageLogModellist;
                }
            }
        }

        public List<CustomerUserMessageLogDetailsModel> GetCustomerUserMessageLogDetails(int CustomerUserMessageLogId)
        {
            List<CustomerUserMessageLogDetailsModel> _CustomerUserMessageLogDetailsModelList = new List<CustomerUserMessageLogDetailsModel>();
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ZnodeECommerceDB"].ConnectionString))
            {
                try
                {
                    SqlCommand command = new SqlCommand("Nivi_GetCustomerUserMessageLogDetails", connection);
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@CustomerUserMessageLogId", CustomerUserMessageLogId);
                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        CustomerUserMessageLogDetailsModel _CustomerUserMessageLogDetailsModel = new CustomerUserMessageLogDetailsModel();
                        _CustomerUserMessageLogDetailsModel.CustomerUserMessageLogDetailsId = Convert.ToInt32(reader["CustomerUserMessageLogDetailsId"]);
                        _CustomerUserMessageLogDetailsModel.CustomerUserMessageLogId = Convert.ToInt32(reader["CustomerUserMessageLogId"]);
                        _CustomerUserMessageLogDetailsModel.UserName = Convert.ToString(reader["UserName"]);
                        _CustomerUserMessageLogDetailsModel.ErrorMessage = Convert.ToString(reader["ErrorMessage"]);
                        _CustomerUserMessageLogDetailsModel.CreatedBy = Convert.ToInt32(reader["CreatedBy"]);
                        _CustomerUserMessageLogDetailsModel.CreatedDate = Convert.ToDateTime(reader["CreatedDate"]);
                        _CustomerUserMessageLogDetailsModelList.Add(_CustomerUserMessageLogDetailsModel);
                    }
                    connection.Close();
                    return _CustomerUserMessageLogDetailsModelList;
                }
                catch (Exception ex)
                {
                    return _CustomerUserMessageLogDetailsModelList;
                }
            }
        }
    }
}
