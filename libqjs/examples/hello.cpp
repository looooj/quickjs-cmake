#include <quickjs.h>
#include <quickjs-libc.h>
#include <string>

void qjs_dump_object(JSContext* ctx, JSValueConst val, std::string& result) {
    const char* str;
    str = JS_ToCString(ctx, val);
    if (str) {
        result.append(str);
        result.append("\n");
        JS_FreeCString(ctx, str);
    } else {
        int tag = JS_VALUE_GET_TAG(val);
        char tmp[256];
        snprintf(tmp, 256, "dump exception tag[%d]", tag);
        result.append(tmp);
    }
}

void qjs_dump_error(JSContext* ctx, JSValueConst exception_val,
                    std::string& result) {
    JSValue val;
    bool is_error;

    is_error = JS_IsError(ctx, exception_val);
    qjs_dump_object(ctx, exception_val, result);
    if (is_error) {
        val = JS_GetPropertyStr(ctx, exception_val, "stack");
        if (!JS_IsUndefined(val)) {
            qjs_dump_object(ctx, val, result);
        }
        JS_FreeValue(ctx, val);
    }
}

void qjs_dump_error(JSContext* ctx, std::string& result) {
    JSValue exception_val;

    exception_val = JS_GetException(ctx);
    qjs_dump_error(ctx, exception_val, result);
    JS_FreeValue(ctx, exception_val);
}

void qjs_run_file(JSContext* ctx, const std::string& filename) {

    size_t file_size=0;
    uint8_t* text = js_load_file(ctx, &file_size, filename.c_str());

    int flags = JS_EVAL_TYPE_MODULE;
    JSValue ret = JS_Eval(ctx, (const char*)text, file_size, filename.c_str(), flags);

    if (JS_IsException(ret)) {

        std::string result;
        qjs_dump_error(ctx, result);
        printf("exception\n %s\n", result.c_str());
    }

    js_free(ctx, text);

}


void js_create_object(JSContext* ctx,const std::string& name)  {


}

void test_01() {

    auto rt = JS_NewRuntime();
    js_std_init_handlers(rt);
    auto ctx = JS_NewContext(rt);

    JS_SetModuleLoaderFunc(rt, NULL, js_module_loader, NULL);

    js_init_module_std(ctx, "std");
    js_init_module_os(ctx, "os");

    js_std_add_helpers(ctx, -1, 0);
    std::string js = "print('hello\\n');";
    JSValue val = JS_Eval(ctx, js.c_str(), js.length(), "", 0);

    if (JS_IsException(val)) {

        std::string result;
        qjs_dump_error(ctx, result);
        printf("exception\n %s\n", result.c_str());
    }

    qjs_run_file(ctx, "hello.js");
    qjs_run_file(ctx, "hello2.js");


    auto v = JS_NewObject(ctx);

    JS_FreeContext(ctx);
    JS_FreeRuntime(rt);
}

int main(int argc, char* argv[]) {

    test_01();
    return 0;
}
