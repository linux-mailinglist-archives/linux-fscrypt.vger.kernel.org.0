Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1854C20BA
	for <lists+linux-fscrypt@lfdr.de>; Thu, 24 Feb 2022 01:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiBXAlN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 23 Feb 2022 19:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiBXAlN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 23 Feb 2022 19:41:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057EFCB90A;
        Wed, 23 Feb 2022 16:40:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ADE360ED9;
        Thu, 24 Feb 2022 00:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C336FC340E7;
        Thu, 24 Feb 2022 00:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645663237;
        bh=ziQOSAhDXJgwY7NYsTem4a1wH3ZzbHa8A+6fyznxquM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kAo7N29V5pBSN6BCtjwBlK2qvGJyvHu6e3bicy24IRCFChqTDY+Lj/X+iDrnaLZEh
         qc/xAO4FbdWU/H6YHvXC+UxyGzXlO0sZq5p+A5+VrKbxsKg+KK2MuKegyTlsmsdZnZ
         y2Fh3P7ldogrybdjrZ9Wuv40kk3wgK4rb2DdtUXK7ZK3BQkyF9D5W18K2I9QMtH1Eb
         my+3L/S5StoTdWu2AgX3VQDQOGcDyXyAaJ8AmguyJSGVKj5bRNBMytKXBV2gm2xRwg
         KIA9j9NKZEPUzdbiN5wOU03rUXKQ7AG0ExxPg25NEb7xu1aVcfNbbm2AQgkZBUJUhr
         eE/16o3aU6cGQ==
Date:   Wed, 23 Feb 2022 16:40:36 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/8] ima: permit fsverity's file digests in the IMA
 measurement list
Message-ID: <YhbUBJbQ+nCN515p@sol.localdomain>
References: <20220211214310.119257-1-zohar@linux.ibm.com>
 <20220211214310.119257-6-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211214310.119257-6-zohar@linux.ibm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Feb 11, 2022 at 04:43:07PM -0500, Mimi Zohar wrote:
> diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
> index 839fab811b18..ff3c906738cb 100644
> --- a/Documentation/ABI/testing/ima_policy
> +++ b/Documentation/ABI/testing/ima_policy
> @@ -51,6 +51,9 @@ Description:
>  			appraise_flag:= [check_blacklist]
>  			Currently, blacklist check is only for files signed with appended
>  			signature.
> +			digest_type:= verity
> +			    Require fs-verity's file digest instead of the
> +			    regular IMA file hash.
>  			keyrings:= list of keyrings
>  			(eg, .builtin_trusted_keys|.ima). Only valid
>  			when action is "measure" and func is KEY_CHECK.
> @@ -149,3 +152,10 @@ Description:
>  		security.ima xattr of a file:
>  
>  			appraise func=SETXATTR_CHECK appraise_algos=sha256,sha384,sha512
> +
> +		Example of 'measure' rule requiring fs-verity's digests on a
> +		particular filesystem with indication of type of digest in
> +		the measurement list.
> +
> +			measure func=FILE_CHECK digest_type=verity \
> +				fsuuid=... template=ima-ngv2
> diff --git a/Documentation/security/IMA-templates.rst b/Documentation/security/IMA-templates.rst
> index 1a91d92950a7..1e3fe986764e 100644
> --- a/Documentation/security/IMA-templates.rst
> +++ b/Documentation/security/IMA-templates.rst
> @@ -69,6 +69,8 @@ descriptors by adding their identifier to the format string
>     algorithm (field format: [<hash algo>:]digest, where the digest
>     prefix is shown only if the hash algorithm is not SHA1 or MD5);
>   - 'd-modsig': the digest of the event without the appended modsig;
> + - 'd-type': differentiate between fs-verity's Merkle tree based file hash
> +   from a regular IMA file hash measurement.
>   - 'n-ng': the name of the event, without size limitations;
>   - 'sig': the file signature, or the EVM portable signature if the file
>     signature is not found;
> @@ -106,3 +108,8 @@ currently the following methods are supported:
>     the ``ima_template=`` parameter;
>   - register a new template descriptor with custom format through the kernel
>     command line parameter ``ima_template_fmt=``.

Is there more IMA documentation elsewhere, or is this everything?  These files
are hard to follow.

> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
> index daf49894fd7d..39a999877013 100644
> --- a/security/integrity/integrity.h
> +++ b/security/integrity/integrity.h
> @@ -32,7 +32,7 @@
>  #define IMA_HASHED		0x00000200
>  
>  /* iint policy rule cache flags */
> -#define IMA_NONACTION_FLAGS	0xff000000
> +#define IMA_NONACTION_FLAGS	0xff800000
>  #define IMA_DIGSIG_REQUIRED	0x01000000
>  #define IMA_PERMIT_DIRECTIO	0x02000000
>  #define IMA_NEW_FILE		0x04000000
> @@ -40,6 +40,8 @@
>  #define IMA_FAIL_UNVERIFIABLE_SIGS	0x10000000
>  #define IMA_MODSIG_ALLOWED	0x20000000
>  #define IMA_CHECK_BLACKLIST	0x40000000
> +#define IMA_VERITY_REQUIRED	0x80000000
> +#define IMA_VERITY_DIGEST	0x00800000

How about defining these flags in numerical order?

- Eric
