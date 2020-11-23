Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABAD72C0073
	for <lists+linux-fscrypt@lfdr.de>; Mon, 23 Nov 2020 08:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgKWHE7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 23 Nov 2020 02:04:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:54305 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726861AbgKWHE6 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 23 Nov 2020 02:04:58 -0500
IronPort-SDR: eswpywBM+ziv7WMyYhncKA/dGbh8sb5TkRhufoxuB0tT0lRLDw6rhKomGO6ZTSyxUhtY1e04lk
 ALEsxwy0vCJw==
X-IronPort-AV: E=McAfee;i="6000,8403,9813"; a="171875377"
X-IronPort-AV: E=Sophos;i="5.78,361,1599548400"; 
   d="scan'208";a="171875377"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2020 23:04:41 -0800
IronPort-SDR: Qp6vNE+Kp14DbsXd3hs6+OEJ2ZFTg3BdgKZcqb/Zhp2InkvPwMD8tGF2FrBqmQ3LjiQkQ2LR0t
 g39Ocph5fDYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,361,1599548400"; 
   d="scan'208";a="327099501"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.94]) ([10.237.72.94])
  by orsmga003.jf.intel.com with ESMTP; 22 Nov 2020 23:04:33 -0800
Subject: Re: [PATCH 0/8] eMMC inline encryption support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Satya Tangirala <satyat@google.com>,
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
 <ea904bcc-3f01-d968-2a16-f9ff9f012968@intel.com>
 <X7gcsC6IS80sUy4K@sol.localdomain>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <9010afea-1075-8f72-99c7-c471840685db@intel.com>
Date:   Mon, 23 Nov 2020 09:04:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <X7gcsC6IS80sUy4K@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 20/11/20 9:44 pm, Eric Biggers wrote:
> Hi Adrian,
> 
> On Fri, Nov 20, 2020 at 09:29:59PM +0200, Adrian Hunter wrote:
>> I haven't had a chance to look at it properly, but I do have a couple of
>> dumb questions.  How do you ensure the host controller is not runtime
>> suspended when the key is programmed?
> 
> This is handled by the block layer, in block/keyslot-manager.c.  It ensures that
> the device is resumed before calling blk_ksm_ll_ops::keyslot_program() or
> blk_ksm_ll_ops::keyslot_evict().  See blk_ksm_hw_enter().

Cool, although cqhci is doing a lazy kind of resume, so maybe not be enabled
when a key is programmed?  Would that be a problem?

> 
>> Are the keys lost when the host controller is reset, and then how do you know
>> the host controller does not get reset after the key is programmed but before
>> the I/O is submitted?
> 
> As with UFS, keys might be lost when the host controller is reset, so we're
> reprogramming all the keys when that happens.  See patch 1:
> 
>     mmc_set_initial_state()
>         mmc_crypto_set_initial_state()
>             blk_ksm_reprogram_all_keys()
> 
> (That's the intent, at least.  For MMC, I'm not sure if resets were properly
> covered by the testing I've done so far.  But the code looks right to me.)

After reset, cqhci will not necessarily be enabled at this point.  Is that OK?
