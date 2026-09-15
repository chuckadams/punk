/*
   A host program that embeds PHP, used by meson as the test for libphp.
   It boots the engine, evaluates a script and checks the result, so a
   regression in the embed SAPI (or in the library it produces) shows up as
   a failing `meson test` rather than only when a host application runs.
*/

#include <sapi/embed/php_embed.h>
#include <zend_execute.h>

int main(int argc, char **argv)
{
	php_embed_init(argc, argv);

	zval retval;
	ZVAL_UNDEF(&retval);
	/* zend_eval_string() prepends "return " itself when a retval is wanted, so
	 * the snippet is only the expression. */
	zend_result status = zend_eval_string("6 * 7", &retval, "embed test");

	int ok = status == SUCCESS
		&& Z_TYPE(retval) == IS_LONG
		&& Z_LVAL(retval) == 42;
	zval_ptr_dtor(&retval);

	php_embed_shutdown();

	return ok ? 0 : 1;
}
