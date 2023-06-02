function testAdminFunc() {
	const bar = 'baz';
	console.log(bar);
}

testAdminFunc.addEventListener('click', () => {
	console.log('hello admin world');
});