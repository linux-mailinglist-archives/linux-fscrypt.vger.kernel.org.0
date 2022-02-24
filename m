Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436C14C2151
	for <lists+linux-fscrypt@lfdr.de>; Thu, 24 Feb 2022 02:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiBXBrE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 23 Feb 2022 20:47:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiBXBrC (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 23 Feb 2022 20:47:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFC7221;
        Wed, 23 Feb 2022 17:46:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0B5B60C83;
        Thu, 24 Feb 2022 00:50:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F0CC340E7;
        Thu, 24 Feb 2022 00:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645663859;
        bh=00lrl6UcD5tDJadETCE9ZmRWSbIqAmhkJXg/tqXIirw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pbSYlBUcJexoGL5pBv1GsRg3JiR/1isNduqCxjKYePY1OOEyGrb6VY3z7AjWyqVRc
         o1wS5dwT0u4YzBgKUYfwtPhihksCjZgOJn1GWVSF79xMP5B0g652Rij5cXnac4/Ut2
         EPm6Nthhznl188RpE1vVmxuWWw0YnM5bhivfp5/oQ5jVAKPSSDG9I25viWemfFRQD7
         2S8JaunAjT8wHG48wxYFdJEfOj6F26WDZAvmzYvMDUb0L24QQ8ckg38d8gTAD0Sr9W
         F9ExNHYlPef4oOBm1J0xWJwuJ3bV7xo/8VFDaFFjuV/FsTVTjf7t/DUrXeppFKn/oo
         iaYvs29rsQsRA==
Date:   Wed, 23 Feb 2022 16:50:57 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 6/8] ima: define signature version 3
Message-ID: <YhbWcRfo/Cz8EyNw@sol.localdomain>
References: <20220211214310.119257-1-zohar@linux.ibm.com>
 <20220211214310.119257-7-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211214310.119257-7-zohar@linux.ibm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Feb 11, 2022 at 04:43:08PM -0500, Mimi Zohar wrote:
> To disambiguate the signed data stored in the 'security.ima' xattr,
> define signature version 3 as the hash of the ima_file_id structure.
> 
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>  security/integrity/digsig.c           |  3 ++-
>  security/integrity/ima/ima_appraise.c | 35 +++++++++++++++++++++++++++
>  security/integrity/integrity.h        | 20 +++++++++++++--
>  3 files changed, 55 insertions(+), 3 deletions(-)
> 
> diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
> index 3b06a01bd0fd..fd8f77d92a62 100644
> --- a/security/integrity/digsig.c
> +++ b/security/integrity/digsig.c
> @@ -74,7 +74,8 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
>  		/* v1 API expect signature without xattr type */
>  		return digsig_verify(keyring, sig + 1, siglen - 1, digest,
>  				     digestlen);
> -	case 2:
> +	case 2: /* regular file data hash based sginature */
> +	case 3: /* struct ima_file_id data base signature */
>  		return asymmetric_verify(keyring, sig, siglen, digest,
>  					 digestlen);
>  	}
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index 17232bbfb9f9..c2b429c141a7 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -225,6 +225,33 @@ int ima_read_xattr(struct dentry *dentry,
>  	return ret;
>  }
>  
> +/*
> + * calc_file_id_hash - calculate the hash of the ima_file_id struct data
> + * @type: xattr type [enum evm_ima_xattr_type]
> + * @algo: hash algorithm [enum hash_algo]
> + * @digest: pointer to the digest to be hashed
> + * @hash: (out) pointer to the hash
> + *
> + * IMA signature version 3 disambiguates the data that is signed by
> + * indirectly signing the hash of the ima_file_id structure data.
> + *
> + * Return 0 on success, error code otherwise.
> + */
> +static int calc_file_id_hash(enum evm_ima_xattr_type type,
> +			     enum hash_algo algo, const u8 *digest,
> +			     struct ima_digest_data *hash)
> +{
> +	struct ima_file_id file_id = {.hash_algorithm = algo};
> +	uint unused = HASH_MAX_DIGESTSIZE - hash_digest_size[algo];
> +
> +	memcpy(file_id.hash, digest, hash_digest_size[algo]);
> +
> +	hash->algo = algo;
> +	hash->length = hash_digest_size[algo];
> +
> +	return ima_calc_buffer_hash(&file_id, sizeof(file_id) - unused, hash);
> +}
> +

calc_file_id_hash() isn't used in this patch.

Perhaps this patch should be merged with the following one?  I don't understand
the point of this patch on its own.

- Eric
