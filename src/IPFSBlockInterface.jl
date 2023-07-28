module IPFSBlockInterface
using IPFS
using Dates:now,DateTime
using IPFS.MyTools
using IPFS:FSType
export IPFSObjectInterface,IPFSFile,category,hasextensionname
abstract type IPFSObjectInterface{T<:FSType} end
struct IPFSFile{T} <: IPFSObjectInterface{T}
    ipfsblock::UnixFS{T}
    category::String
    createtime::DateTime
    IPFSFile(ipfsblock,category)=new{T}(ipfsblock,category,now())
end

IPFS.toUrl(cid::IPFSObjectInterface,webgate::String)=IPFS.toUrl(cid.ipfsblock,webgate)
@delegate_onefield(IPFSObjectInterface,ipfsblock,[IPFS.cid,IPFS.name,IPFS.toLocalUrl])

category(self::IPFSObjectInterface)=self.category
hasextensionname(self::IPFSObjectInterface)=hasproperty(self,:extensionname)
function Base.splitext(self::IPFSObjectInterface)
    isdir(self.ipfsblock)||error("Not a file")
    Base.splitext(name(self))
end
# function save(f::File{format"JLD2"},datas::Vector{IPFSObjectInterface})
#     jldopen(f.filename, "w") do f
#         for (i,(data)) in enumerate(datas)
#             f[i]=data
#         end
#     end
# end

# struct IPFSDirectory <:IPFSObjectInterface

# end
end # module IPFSBlockInterface
