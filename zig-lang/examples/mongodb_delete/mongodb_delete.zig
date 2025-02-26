const std = @import("std");
const c = @cImport({
    @cInclude("mongoc/mongoc.h");
});

pub fn main() !void {
    // 初始化 MongoDB 客户端
    c.mongoc_init();

    // 连接 MongoDB
    const client = c.mongoc_client_new("mongodb://localhost:27017") orelse {
        std.debug.print("Failed to connect to MongoDB\n", .{});
        return;
    };

    // 选择数据库和集合
    const collection = c.mongoc_client_get_collection(client, "test_db", "test_collection");

    // 构造删除条件 (例如: 删除 `{"name": "Alice"}` 的数据)
    const query = c.bson_new_from_json("{\"name\": \"Alice\"}", -1, null);
    if (query == null) {
        std.debug.print("Failed to create BSON query\n", .{});
        return;
    }

    // 执行删除操作
    var reply: c.bson_t = undefined;
    var bson_err: c.bson_error_t = undefined;
    const delete_result = c.mongoc_collection_delete_one(collection, query, null, &reply, &bson_err);

    if (delete_result) {
        std.debug.print("Document deleted successfully.\n", .{});
    } else {
        std.debug.print("Failed to delete document: {s}\n", .{&bson_err.message});
    }

    // 释放资源
    c.bson_destroy(query);
    c.mongoc_collection_destroy(collection);
    c.mongoc_client_destroy(client);
    c.mongoc_cleanup();
}
