Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173772CCFBF
	for <lists+linux-fscrypt@lfdr.de>; Thu,  3 Dec 2020 07:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729424AbgLCGqZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 3 Dec 2020 01:46:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:30235 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728515AbgLCGqY (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 3 Dec 2020 01:46:24 -0500
IronPort-SDR: b/zlEpb9E24EOH6xhr6B0WUBwuxS4Mbs4sqIi0KsNSFKpUQRh3ynujpSNBWP3jcVnTlh6vHV8r
 gOjxSD6Ag3PA==
X-IronPort-AV: E=McAfee;i="6000,8403,9823"; a="160200587"
X-IronPort-AV: E=Sophos;i="5.78,388,1599548400"; 
   d="scan'208";a="160200587"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 22:45:43 -0800
IronPort-SDR: r2/8DskmGEjMpXiK/ddrQBRQe+S74yuHkvugcKQGVW6IHsMZwlLFKT6srJ04M6lP2Lrh6js1rY
 FRSDOerJ701g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,388,1599548400"; 
   d="scan'208";a="330729008"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.94]) ([10.237.72.94])
  by orsmga003.jf.intel.com with ESMTP; 02 Dec 2020 22:45:40 -0800
Subject: Re: [PATCH v2 3/9] mmc: cqhci: initialize upper 64 bits of 128-bit
 task descriptors
To:     Eric Biggers <ebiggers@kernel.org>, linux-mmc@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Peng Zhou <peng.zhou@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Konrad Dybcio <konradybcio@gmail.com>
References: <20201203020516.225701-1-ebiggers@kernel.org>
 <20201203020516.225701-4-ebiggers@kernel.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <bf74d785-a88e-f621-24a3-4e68aeeee753@intel.com>
Date:   Thu, 3 Dec 2020 08:45:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201203020516.225701-4-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 3/12/20 4:05 am, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Move the task descriptor initialization into cqhci_prep_task_desc(), and
> make it initialize all 128 bits of the task descriptor if the host
> controller is using 128-bit task descriptors.
> 
> This is needed to prepare for CQHCI inline encryption support, which
> requires 128-bit task descriptors and uses the upper 64 bits.
> 
> Note: since some host controllers already enable 128-bit task
> descriptors, it's unclear why the previous code worked when it wasn't
> initializing the upper 64 bits.  One possibility is that the bits are
> being ignored because the features that use them aren't enabled yet.
> In any case, setting them to 0 won't hurt.

Coherent allocations are zero-initialized.  So the upper 64-bits stay zero.
People set 128-bit anyway because the hardware needs it.

> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/mmc/host/cqhci-core.c | 30 ++++++++++++++++++++----------
>  1 file changed, 20 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/mmc/host/cqhci-core.c b/drivers/mmc/host/cqhci-core.c
> index 697fe40756bf2..ad7c9acff1728 100644
> --- a/drivers/mmc/host/cqhci-core.c
> +++ b/drivers/mmc/host/cqhci-core.c
> @@ -408,13 +408,15 @@ static void cqhci_disable(struct mmc_host *mmc)
>  }
>  
>  static void cqhci_prep_task_desc(struct mmc_request *mrq,
> -					u64 *data, bool intr)
> +				 struct cqhci_host *cq_host, int tag)
>  {
> +	__le64 *task_desc = (__le64 __force *)get_desc(cq_host, tag);
>  	u32 req_flags = mrq->data->flags;
> +	u64 desc0;
>  
> -	*data = CQHCI_VALID(1) |
> +	desc0 = CQHCI_VALID(1) |
>  		CQHCI_END(1) |
> -		CQHCI_INT(intr) |
> +		CQHCI_INT(1) |
>  		CQHCI_ACT(0x5) |
>  		CQHCI_FORCED_PROG(!!(req_flags & MMC_DATA_FORCED_PRG)) |
>  		CQHCI_DATA_TAG(!!(req_flags & MMC_DATA_DAT_TAG)) |
> @@ -425,8 +427,19 @@ static void cqhci_prep_task_desc(struct mmc_request *mrq,
>  		CQHCI_BLK_COUNT(mrq->data->blocks) |
>  		CQHCI_BLK_ADDR((u64)mrq->data->blk_addr);
>  
> -	pr_debug("%s: cqhci: tag %d task descriptor 0x%016llx\n",
> -		 mmc_hostname(mrq->host), mrq->tag, (unsigned long long)*data);
> +	task_desc[0] = cpu_to_le64(desc0);
> +
> +	if (cq_host->caps & CQHCI_TASK_DESC_SZ_128) {
> +		u64 desc1 = 0;
> +
> +		task_desc[1] = cpu_to_le64(desc1);
> +
> +		pr_debug("%s: cqhci: tag %d task descriptor 0x%016llx%016llx\n",
> +			 mmc_hostname(mrq->host), mrq->tag, desc1, desc0);
> +	} else {
> +		pr_debug("%s: cqhci: tag %d task descriptor 0x%016llx\n",
> +			 mmc_hostname(mrq->host), mrq->tag, desc0);
> +	}
>  }
>  
>  static int cqhci_dma_map(struct mmc_host *host, struct mmc_request *mrq)
> @@ -567,8 +580,6 @@ static inline int cqhci_tag(struct mmc_request *mrq)
>  static int cqhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
>  {
>  	int err = 0;
> -	u64 data = 0;
> -	u64 *task_desc = NULL;
>  	int tag = cqhci_tag(mrq);
>  	struct cqhci_host *cq_host = mmc->cqe_private;
>  	unsigned long flags;
> @@ -598,9 +609,8 @@ static int cqhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
>  	}
>  
>  	if (mrq->data) {
> -		task_desc = (__le64 __force *)get_desc(cq_host, tag);
> -		cqhci_prep_task_desc(mrq, &data, 1);
> -		*task_desc = cpu_to_le64(data);
> +		cqhci_prep_task_desc(mrq, cq_host, tag);
> +
>  		err = cqhci_prep_tran_desc(mrq, cq_host, tag);
>  		if (err) {
>  			pr_err("%s: cqhci: failed to setup tx desc: %d\n",
> 

