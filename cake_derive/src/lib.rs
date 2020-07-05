extern crate proc_macro;

use proc_macro::TokenStream;
use proc_macro2::TokenStream as TokenStream2;

#[proc_macro_derive(Component)]
pub fn component_derive(input: TokenStream) -> TokenStream {
    let ast: syn::DeriveInput = syn::parse(input).unwrap();
    let stream: TokenStream2 =
        syn::parse_str::<TokenStream2>(&format!("impl Component for {} {{}}", &ast.ident)).unwrap();
    stream.into()
}
