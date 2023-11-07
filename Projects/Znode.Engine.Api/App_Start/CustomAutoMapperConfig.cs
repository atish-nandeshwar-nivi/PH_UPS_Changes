using AutoMapper;
using Znode.Custom.Data;
using Znode.Api.Model.Custom;

namespace Znode.Engine.Api
{
    public static class CustomAutoMapperConfig
    {
        public static void Execute()
        {
            Mapper.CreateMap<ZnodeCustomPortalDetail, CustomPortalDetailModel>().ReverseMap();
        }
    }
}