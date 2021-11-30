Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F14D462C51
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Nov 2021 06:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbhK3Ftt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 30 Nov 2021 00:49:49 -0500
Received: from linux.microsoft.com ([13.77.154.182]:47674 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbhK3Ftt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 30 Nov 2021 00:49:49 -0500
Received: from [10.137.112.111] (unknown [131.107.147.111])
        by linux.microsoft.com (Postfix) with ESMTPSA id 89CA020E0A31;
        Mon, 29 Nov 2021 21:46:30 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 89CA020E0A31
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1638251190;
        bh=iOpaHr6qFasi/i3ytiPPbRmOJGx7HOYQVOOl1pw3WQU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=QzzGMgkEAX/wnqax1mqf2ie8IqhrQEhsq/azjEprLq4Ns6cTuJ/IbR/7JyhXmVEp9
         eHQZ1FWX9Nd4OmMwGwhIvUZ9+26W7/EVzkeIn6fKuoW1tAxdhMj1BQtMppJyA1nBgu
         yAsqPUl5vMWaCS86zgx1yKihEUxKCHxEs0QP7Nxs=
Message-ID: <e99c6bdd-de23-7e07-37ce-c01b51961402@linux.microsoft.com>
Date:   Mon, 29 Nov 2021 21:46:30 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 3/4] ima: limit including fs-verity's file digest in
 measurement list
Content-Language: en-US
To:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
References: <20211129170057.243127-1-zohar@linux.ibm.com>
 <20211129170057.243127-4-zohar@linux.ibm.com>
From:   Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
In-Reply-To: <20211129170057.243127-4-zohar@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Mimi,

Just one nit comment below in the patch description.

On 11/29/2021 9:00 AM, Mimi Zohar wrote:
> Without the file signature included the IMA measurement list, the type
Without the file signature included in the IMA measurement list, the type...

  -lakshmi

> of file digest is unclear.  Limit including fs-verity's file digest in
> the IMA measurement list based on whether the template name is ima-sig.
> In the future, this could be relaxed to include any template format that
> includes the file signature.
> 
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>   security/integrity/ima/ima.h              | 3 ++-
>   security/integrity/ima/ima_api.c          | 3 ++-
>   security/integrity/ima/ima_appraise.c     | 3 ++-
>   security/integrity/ima/ima_main.c         | 7 ++++++-
>   security/integrity/ima/ima_template_lib.c | 3 ++-
>   5 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index be965a8715e4..ab257e404f8e 100644
> --- a/security/integrity/ima/ima.h
> +++ b/security/integrity/ima/ima.h
> @@ -262,7 +262,8 @@ int ima_get_action(struct user_namespace *mnt_userns, struct inode *inode,
>   int ima_must_measure(struct inode *inode, int mask, enum ima_hooks func);
>   int ima_collect_measurement(struct integrity_iint_cache *iint,
>   			    struct file *file, void *buf, loff_t size,
> -			    enum hash_algo algo, struct modsig *modsig);
> +			    enum hash_algo algo, struct modsig *modsig,
> +			    bool veritysig);
>   void ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
>   			   const unsigned char *filename,
>   			   struct evm_ima_xattr_data *xattr_value,
> diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
> index 42c6ff7056e6..179c7f0364c2 100644
> --- a/security/integrity/ima/ima_api.c
> +++ b/security/integrity/ima/ima_api.c
> @@ -217,7 +217,8 @@ int ima_get_action(struct user_namespace *mnt_userns, struct inode *inode,
>    */
>   int ima_collect_measurement(struct integrity_iint_cache *iint,
>   			    struct file *file, void *buf, loff_t size,
> -			    enum hash_algo algo, struct modsig *modsig)
> +			    enum hash_algo algo, struct modsig *modsig,
> +			    bool veritysig)
>   {
>   	const char *audit_cause = "failed";
>   	struct inode *inode = file_inode(file);
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index d43a27a9a9b6..b31be383e668 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -510,7 +510,8 @@ void ima_update_xattr(struct integrity_iint_cache *iint, struct file *file)
>   	    !(iint->flags & IMA_HASH))
>   		return;
>   
> -	rc = ima_collect_measurement(iint, file, NULL, 0, ima_hash_algo, NULL);
> +	rc = ima_collect_measurement(iint, file, NULL, 0, ima_hash_algo,
> +				     NULL, FALSE);
>   	if (rc < 0)
>   		return;
>   
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 465865412100..a73e1e845ea8 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -216,6 +216,7 @@ static int process_measurement(struct file *file, const struct cred *cred,
>   	bool violation_check;
>   	enum hash_algo hash_algo;
>   	unsigned int allowed_algos = 0;
> +	int veritysig = FALSE;
>   
>   	if (!ima_policy_flag || !S_ISREG(inode->i_mode))
>   		return 0;
> @@ -333,8 +334,12 @@ static int process_measurement(struct file *file, const struct cred *cred,
>   	}
>   
>   	hash_algo = ima_get_hash_algo(xattr_value, xattr_len);
> +	if (xattr_value && xattr_value->type == IMA_VERITY_DIGSIG &&
> +	    strcmp(template_desc->name, "ima-sig") == 0)
> +		veritysig = TRUE;
>   
> -	rc = ima_collect_measurement(iint, file, buf, size, hash_algo, modsig);
> +	rc = ima_collect_measurement(iint, file, buf, size, hash_algo,
> +				     modsig, veritysig);
>   	if (rc != 0 && rc != -EBADF && rc != -EINVAL)
>   		goto out_locked;
>   
> diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
> index ca017cae73eb..5bad251f3b07 100644
> --- a/security/integrity/ima/ima_template_lib.c
> +++ b/security/integrity/ima/ima_template_lib.c
> @@ -478,7 +478,8 @@ int ima_eventsig_init(struct ima_event_data *event_data,
>   {
>   	struct evm_ima_xattr_data *xattr_value = event_data->xattr_value;
>   
> -	if ((!xattr_value) || (xattr_value->type != EVM_IMA_XATTR_DIGSIG))
> +	if ((!xattr_value) || !(xattr_value->type == EVM_IMA_XATTR_DIGSIG ||
> +				xattr_value->type == IMA_VERITY_DIGSIG))
>   		return ima_eventevmsig_init(event_data, field_data);
>   
>   	return ima_write_template_field_data(xattr_value, event_data->xattr_len,
> 
