function testFunc() {
	const foo = 'bar';
	console.log(foo);
}

testFunc.addEventListener('click', () => {
	console.log('hello world');
});