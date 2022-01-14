// Copyright (c) 2018-2022, Firas Khalil Khana
// Distributed under the terms of the ISC License

mod architecture;
mod ceras;
mod clean;
mod constants;
mod flags;
mod functions;
mod image;
mod options;
mod swallow;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    options::radula_options().await?;

    Ok(())
}
