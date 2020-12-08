Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDB92D371A
	for <lists+linux-fscrypt@lfdr.de>; Wed,  9 Dec 2020 00:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730353AbgLHXqn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Dec 2020 18:46:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730366AbgLHXqn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Dec 2020 18:46:43 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1FCC061794
        for <linux-fscrypt@vger.kernel.org>; Tue,  8 Dec 2020 15:46:03 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id 11so206732pfu.4
        for <linux-fscrypt@vger.kernel.org>; Tue, 08 Dec 2020 15:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4yKNxCl+vQDHfatyg/GcsY0hnIkoBzf+/9KfiXssTbk=;
        b=j3cf3covSKiEEgqlptY0VhDHLRYGHGX9Rccbg6vafc+TS1yoTZDylFNBgVeGm5CpEq
         QA1vi/34q9BSpQrH+Vy2eP/Dqse2qrDAd7HxQ7GsdDYxPPFCYH9HYesNAaVsawl9Fk2s
         OBWYBDDPBWKTqvL64Wlz2AaWL//qdrpUq+sFSQpTWtBzDvhqw4hhtizgvGXd0WOtiYlx
         Mjd93cLFHgt8ILpIY20BdoA1LTDGQm8/WYdPvXxl92lgL64EyDwM7Va32QKArcaWIxZY
         HrAob+eVigI2Uz3yGRCe6NjbcH7oWvRes+TIKhfwbIkB4ZDJ3ZGK5gP2VDhi5vS15ORr
         F6QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4yKNxCl+vQDHfatyg/GcsY0hnIkoBzf+/9KfiXssTbk=;
        b=oqE5rseVnxw0Hx0i3+phHpIMfYN4b49y014LdOblvCkC/uIzTZp7WN6aMXQTzr8yx3
         skm5BfCeY3sTYVhK7/uoQmiNb9Wk/UoC7/lb8n8FP/CQyoxBOar4S08cIy8M/44/pSjf
         ZA/ewS1yyx2WC1b5jxt6C6i4WiL+d1abUYM5soqDAhVOYNIUHZHwJw/g5VuMze3pA8vO
         OHMWpMtmWxkwGm5VNks9gKRwwt2lJTPvbz4PIlVXE0g4xi9canGOA/NsIfJfUc3by9s0
         H0f8ova3vJp23dZRPfjh7+g3MWO6+3P035ypQbDAJKca1j3b7wAz1cBcWzIEq3hRDOXU
         Dajw==
X-Gm-Message-State: AOAM531X5FRwbmVtd0JoFyDlUavOdO+ctN42hb6rQwiiFS57unbszcpN
        z93SO94xV5EzXwfQ4BUfPQ+QmA==
X-Google-Smtp-Source: ABdhPJyI/vseLuf6fqn0RbssnJqSnhSx2Zt0Y1bE1VF6+Ho9YPaIoTKi8qTqmMHsuVmheP/0V9yFcQ==
X-Received: by 2002:a17:90a:e386:: with SMTP id b6mr164919pjz.134.1607471162567;
        Tue, 08 Dec 2020 15:46:02 -0800 (PST)
Received: from google.com (154.137.233.35.bc.googleusercontent.com. [35.233.137.154])
        by smtp.gmail.com with ESMTPSA id x6sm82407pgr.20.2020.12.08.15.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 15:46:01 -0800 (PST)
Date:   Tue, 8 Dec 2020 23:45:58 +0000
From:   Satya Tangirala <satyat@google.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Peng Zhou <peng.zhou@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Konrad Dybcio <konradybcio@gmail.com>
Subject: Re: [PATCH v2 3/9] mmc: cqhci: initialize upper 64 bits of 128-bit
 task descriptors
Message-ID: <X9AQNsePlMQK7a0i@google.com>
References: <20201203020516.225701-1-ebiggers@kernel.org>
 <20201203020516.225701-4-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203020516.225701-4-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Dec 02, 2020 at 06:05:10PM -0800, Eric Biggers wrote:
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
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
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
> -- 
> 2.29.2
> 
Looks good to me. Please feel free to add
Reviewed-by: Satya Tangirala <satyat@google.com>
