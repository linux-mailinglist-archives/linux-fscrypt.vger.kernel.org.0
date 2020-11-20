Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584302BB573
	for <lists+linux-fscrypt@lfdr.de>; Fri, 20 Nov 2020 20:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732398AbgKTTa1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 20 Nov 2020 14:30:27 -0500
Received: from mga03.intel.com ([134.134.136.65]:23023 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729137AbgKTTa1 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 20 Nov 2020 14:30:27 -0500
IronPort-SDR: 68spS8s2X16MqsMM/HIah9JwjqwkeKnexFXjDpPujhSYJZzTYWdbvky/yl5oYwFBSk0RJc4OXF
 oaEuD/B/JLOA==
X-IronPort-AV: E=McAfee;i="6000,8403,9811"; a="171628750"
X-IronPort-AV: E=Sophos;i="5.78,357,1599548400"; 
   d="scan'208";a="171628750"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2020 11:30:26 -0800
IronPort-SDR: 6F3m5G0UnmyqkEQSm+JWn+qVdmY/Up0r14PLs4LtOpPn9M24tZ6nPt+UC3vQD87+GQAREQI7pu
 uucMh9h8SuKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,357,1599548400"; 
   d="scan'208";a="312138648"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.94]) ([10.237.72.94])
  by fmsmga007.fm.intel.com with ESMTP; 20 Nov 2020 11:30:19 -0800
Subject: Re: [PATCH 0/8] eMMC inline encryption support
To:     Eric Biggers <ebiggers@kernel.org>, linux-mmc@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Peng Zhou <peng.zhou@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Konrad Dybcio <konradybcio@gmail.com>
References: <20201112194011.103774-1-ebiggers@kernel.org>
 <X7gQ9Y44iIgkiM64@sol.localdomain>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <ea904bcc-3f01-d968-2a16-f9ff9f012968@intel.com>
Date:   Fri, 20 Nov 2020 21:29:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <X7gQ9Y44iIgkiM64@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 20/11/20 8:54 pm, Eric Biggers wrote:
> On Thu, Nov 12, 2020 at 11:40:03AM -0800, Eric Biggers wrote:
>> Hello,
>>
>> This patchset adds support for eMMC inline encryption, as specified by
>> the upcoming version of the eMMC specification and as already
>> implemented and used on many devices.  Building on that, it then adds
>> Qualcomm ICE support and wires it up for the Snapdragon 630 SoC.
>>
>> Inline encryption hardware improves the performance of storage
>> encryption and reduces power usage.  See
>> Documentation/block/inline-encryption.rst for more information about
>> inline encryption and the blk-crypto framework (upstreamed in v5.8)
>> which supports it.  Most mobile devices already use UFS or eMMC inline
>> encryption hardware; UFS support was already upstreamed in v5.9.
>>
>> Patches 1-3 add support for the standard eMMC inline encryption.
>>
>> However, as with UFS, host controller-specific patches are needed on top
>> of the standard support.  Therefore, patches 4-8 add Qualcomm ICE
>> (Inline Crypto Engine) support and wire it up on the Snapdragon 630 SoC.
>>
>> To test this I took advantage of the recently upstreamed support for the
>> Snapdragon 630 SoC, plus work-in-progress patches from the SoMainline
>> project (https://github.com/SoMainline/linux/tree/konrad/v5.10-rc3).  In
>> particular, I was able to run the fscrypt xfstests for ext4 and f2fs in
>> a Debian chroot.  Among other things, these tests verified that the
>> correct ciphertext is written to disk (the same as software encryption).
>>
>> It will also be possible to add support for Mediatek eMMC inline
>> encryption hardware in mtk-sd, and it should be easier than the Qualcomm
>> hardware since the Mediatek hardware follows the standard more closely.
>> I.e., patches 1-3 should be almost enough for the Mediatek hardware.
>> However, I don't have the hardware to do this yet.
>>
>> This patchset is based on v5.10-rc3, and it can also be retrieved from
>> tag "mmc-crypto-v1" of
>> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
>>
>> Note: the fscrypt inline encryption support is partially broken in
>> v5.10-rc3, so for testing a fscrypt fix needs to be applied too:
>> https://lkml.kernel.org/r/20201111015224.303073-1-ebiggers@kernel.org
>>
>> Eric Biggers (8):
>>   mmc: add basic support for inline encryption
>>   mmc: cqhci: rename cqhci.c to cqhci-core.c
>>   mmc: cqhci: add support for inline encryption
>>   mmc: cqhci: add cqhci_host_ops::program_key
>>   firmware: qcom_scm: update comment for ICE-related functions
>>   dt-bindings: mmc: sdhci-msm: add ICE registers and clock
>>   arm64: dts: qcom: sdm630: add ICE registers and clocks
>>   mmc: sdhci-msm: add Inline Crypto Engine support
> 
> Any comments on this patchset?

I haven't had a chance to look at it properly, but I do have a couple of
dumb questions.  How do you ensure the host controller is not runtime
suspended when the key is programmed?  Are the keys lost when the host
controller is reset, and then how do you know the host controller does not
get reset after the key is programmed but before the I/O is submitted?
