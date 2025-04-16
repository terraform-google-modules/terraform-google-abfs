// Copyright 2025 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

# This file is maintained automatically by "terraform init".
# Manual edits may be lost in future updates.

provider "registry.terraform.io/hashicorp/cloudinit" {
  version = "2.3.5"
  hashes = [
    "h1:HCoabXm6NQwCivl1q24+l9VUufc2mFqNeulsQBA9iFg=",
    "zh:17c20574de8eb925b0091c9b6a4d859e9d6e399cd890b44cfbc028f4f312ac7a",
    "zh:348664d9a900f7baf7b091cf94d657e4c968b240d31d9e162086724e6afc19d5",
    "zh:5a876a468ffabff0299f8348e719cb704daf81a4867f8c6892f3c3c4add2c755",
    "zh:6ef97ee4c8c6a69a3d36746ba5c857cf4f4d78f32aa3d0e1ce68f2ece6a5dba5",
    "zh:78d5eefdd9e494defcb3c68d282b8f96630502cac21d1ea161f53cfe9bb483b3",
    "zh:8283e5a785e3c518a440f6ac6e7cc4fc07fe266bf34974246f4e2ef05762feda",
    "zh:a44eb5077950168b571b7eb65491246c00f45409110f0f172cc3a7605f19dba9",
    "zh:aa0806cbff72b49c1b389c0b8e6904586e5259c08dabb7cb5040418568146530",
    "zh:bec4613c3beaad9a7be7ca99cdb2852073f782355b272892e6ee97a22856aec1",
    "zh:d7fe368577b6c8d1ae44c751ed42246754c10305c7f001cc0109833e95aa107d",
    "zh:df2409fc6a364b1f0a0f8a9cd8a86e61e80307996979ce3790243c4ce88f2915",
    "zh:ed3c263396ff1f4d29639cc43339b655235acf4d06296a7c120a80e4e0fd6409",
  ]
}

provider "registry.terraform.io/hashicorp/google" {
  version     = "6.6.0"
  constraints = ">= 3.33.0, >= 3.43.0, >= 3.53.0, >= 3.83.0, >= 4.25.0, >= 4.40.0, >= 4.51.0, >= 4.64.0, < 7.0.0"
  hashes = [
    "h1:mllWOZFO8u2kD2kRTdDDAa8Jt+vb8Uxhf6C0lwLxoz8=",
    "zh:0c181f9b9f0ab81731e5c4c2d20b6d342244506687437dad94e279ef2a588f68",
    "zh:12a4c333fc0ba670e87f09eb574e4b7da90381f9929ef7c866048b6841cc8a6a",
    "zh:15c277c2052df89429051350df4bccabe4cf46068433d4d8c673820d9756fc00",
    "zh:35d1663c81b81cd98d768fa7b80874b48c51b27c036a3c598a597f653374d3c8",
    "zh:56b268389758d544722a342da4174c486a40ffa2a49b45a06111fe31c6c9c867",
    "zh:abd3ea8c3a62928ba09ba7eb42b52f53e682bd65e92d573f1739596b5a9a67b1",
    "zh:be55a328d61d9db58690db74ed43614111e1105e5e52cee15acaa062df4e233e",
    "zh:ce2317ce9fd02cf14323f9e061c43a415b4ae9b3f96046460d0e6b6529a5aa6c",
    "zh:d54a6d8e031c824f1de21b93c3e01ed7fec134b4ae55223d08868c6168c98e47",
    "zh:d8c6e33b5467c6eb5a970adb251c4c8194af12db5388cff9d4b250294eae4daa",
    "zh:f49e4cc9c0b55b3bec7da64dd698298345634a5df372228ee12aa45e57982f64",
    "zh:f569b65999264a9416862bca5cd2a6177d94ccb0424f3a4ef424428912b9cb3c",
  ]
}

provider "registry.terraform.io/hashicorp/google-beta" {
  version     = "6.6.0"
  constraints = ">= 3.43.0, >= 4.40.0, >= 4.64.0, < 7.0.0"
  hashes = [
    "h1:B4Wrkju7TTLWlCIDh+Vh4knFQS3wmFm0NHICGjCNO3k=",
    "zh:1bf8f840a9a4ac1e120a6155225a0defbfa7f07b19c9bb37b45f95006b020ccf",
    "zh:39077f037e611bdbd6af42e51b2881ea03d62ad55f21b42f90dc09e2cf812753",
    "zh:64313dd2158749e3a4f2759edb896a9efa2c2afc59feb38d3af57e31eaa64480",
    "zh:6bec8b21a20f50d81ca2e633cdaf1144bb8615a1dedf50e87c86f4eda3467b05",
    "zh:74566c568410997fe966ef44130d19d640dbb427ffec3de93f0fd2affeb6fd8f",
    "zh:8fe1c42d3229d0fe64961b7fa480689408eff3e5be62eb108d6aa9d36a10a769",
    "zh:9593b59efd271623f45d133164eae16676130439727a625c10d3b929d2f28671",
    "zh:a72c71431523d1f0d0d8baf7141ff16aa5938c0edf27e05dc4d1dc3455a50d01",
    "zh:cbc96a215575d94601ec315a2db8802b521e904aaecf2602bce0110786cfa81f",
    "zh:e71c3e06e861d5c9d1782b0bbaef93b5b9defa926304f90ddd22bc9b69ee14bd",
    "zh:f559eefcc67d771ce0157e7ec021c1025b8af2a8c7ca89e1f5ac812e16bf9760",
    "zh:f569b65999264a9416862bca5cd2a6177d94ccb0424f3a4ef424428912b9cb3c",
  ]
}

provider "registry.terraform.io/hashicorp/random" {
  version     = "3.6.3"
  constraints = "~> 3.0"
  hashes = [
    "h1:Fnaec9vA8sZ8BXVlN3Xn9Jz3zghSETIKg7ch8oXhxno=",
    "zh:04ceb65210251339f07cd4611885d242cd4d0c7306e86dda9785396807c00451",
    "zh:448f56199f3e99ff75d5c0afacae867ee795e4dfda6cb5f8e3b2a72ec3583dd8",
    "zh:4b4c11ccfba7319e901df2dac836b1ae8f12185e37249e8d870ee10bb87a13fe",
    "zh:4fa45c44c0de582c2edb8a2e054f55124520c16a39b2dfc0355929063b6395b1",
    "zh:588508280501a06259e023b0695f6a18149a3816d259655c424d068982cbdd36",
    "zh:737c4d99a87d2a4d1ac0a54a73d2cb62974ccb2edbd234f333abd079a32ebc9e",
    "zh:78d5eefdd9e494defcb3c68d282b8f96630502cac21d1ea161f53cfe9bb483b3",
    "zh:a357ab512e5ebc6d1fda1382503109766e21bbfdfaa9ccda43d313c122069b30",
    "zh:c51bfb15e7d52cc1a2eaec2a903ac2aff15d162c172b1b4c17675190e8147615",
    "zh:e0951ee6fa9df90433728b96381fb867e3db98f66f735e0c3e24f8f16903f0ad",
    "zh:e3cdcb4e73740621dabd82ee6a37d6cfce7fee2a03d8074df65086760f5cf556",
    "zh:eff58323099f1bd9a0bec7cb04f717e7f1b2774c7d612bf7581797e1622613a0",
  ]
}
