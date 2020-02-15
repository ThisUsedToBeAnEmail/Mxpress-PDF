use Test::More;

use_ok('Mxpress::PDF');

my @data = qw/aaaaaa
bbbbb
cccc
eeee
ooooo
sssss/;

my $gen_text = sub { join( ' ', map { $data[int(rand(scalar @data))] } 0 .. int(rand(shift))) };

my $pdf = Mxpress::PDF->new_pdf('test',
	page => {
		background => '#000',
		padding => 10
	},
	toc => {
		font => { colour => '#00f' },
	},
	title => {
		font => { 
			colour => '#f00',
		},
		margin_bottom => 5,
	},
	subtitle => {
		font => { 
			colour => '#0ff', 
		},
		margin_bottom => 5,
	},
	subsubtitle => {
		font => { 
			colour => '#f0f',
		},
		margin_bottom => 5,
	},
	text => {
		font => { align => 'justify', colour => '#fff' },
		margin_bottom => 5,
		align => 'justify'
	},
)->add_page;

$pdf->page->header->add(
	show_page_num => 'right',
	page_num_text => "page {num}",
	cb => ['text', 'add', 'Header of the page', align => 'center', font => Mxpress::PDF->font($pdf, colour => '#f00') ],
	h => $pdf->mmp(10),
	padding => 10
);

$pdf->page->footer->add(
	show_page_num => 'left',
	cb => ['text', 'add', 'Footer of the page', align => 'center', font => Mxpress::PDF->font($pdf, colour => '#f00') ],
	h => $pdf->mmp(10),
	padding => 10
);

$pdf->title->add(
	$gen_text->(5)
)->toc->placeholder;

$pdf->add_page;
$pdf->page->columns(2);
$pdf->page->rows(2);

for (0 .. 100) {
	$pdf->toc->add( 
		[qw/title subtitle subsubtitle/]->[int(rand(3))] => $gen_text->(4) 
	)->text->add( $gen_text->(1000) );
}

$pdf->save;

done_testing();
