Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E7B4F54E5
	for <lists+linux-fscrypt@lfdr.de>; Wed,  6 Apr 2022 07:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349094AbiDFFP2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 6 Apr 2022 01:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387042AbiDEVuz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 5 Apr 2022 17:50:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49238D681;
        Tue,  5 Apr 2022 13:35:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDA43619AF;
        Tue,  5 Apr 2022 20:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30537C385A1;
        Tue,  5 Apr 2022 20:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649190926;
        bh=5AMYXQake7hH4Sl7hM9HYLwlrWswqrY810AOuA4uvuY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i0h8TOPZyYXw7YxYxsVl6M7m9galZt/HSu2NrnpCZivNyZ7yuqNR6VPzSsh9B5xZ7
         wEI8GFAsRtI1+5cpvV4y5V6bD7ZTHWPrNms51oMeBLqlbhz/Pt4jHjEr4YMtpS04bv
         inUsXA39X6lGwlO1xGyJPxEYe1/qPedJg+ZQA8CccgWdLyfHb14wrrbhHpPIc+xAb6
         2Kx5UkD3i6eV7U8TpRrO27fFNcv6EyK0xn1bXYnJaKFcb7onhVzGsI0JoyGopO2ej3
         a1PNnKsF+R00mz8wCgz30M0lR6/Fgfb+1bACZztdZ/k/7a5j2fhFUCttN/z9s5wiPu
         gNWEMYwCMmdpw==
Date:   Tue, 5 Apr 2022 20:35:24 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 5/5] fsverity: update the documentation
Message-ID: <YkyoDE3HPkxcV1jM@gmail.com>
References: <20220325223824.310119-1-zohar@linux.ibm.com>
 <20220325223824.310119-6-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325223824.310119-6-zohar@linux.ibm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Mar 25, 2022 at 06:38:24PM -0400, Mimi Zohar wrote:
> Update the fsverity documentation related to IMA signature support.
> 
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>  Documentation/filesystems/fsverity.rst | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
> index 1d831e3cbcb3..c1d355f17a54 100644
> --- a/Documentation/filesystems/fsverity.rst
> +++ b/Documentation/filesystems/fsverity.rst
> @@ -74,8 +74,12 @@ authenticating the files is up to userspace.  However, to meet some
>  users' needs, fs-verity optionally supports a simple signature
>  verification mechanism where users can configure the kernel to require
>  that all fs-verity files be signed by a key loaded into a keyring; see
> -`Built-in signature verification`_.  Support for fs-verity file hashes
> -in IMA (Integrity Measurement Architecture) policies is also planned.
> +`Built-in signature verification`_.
> +
> +The Integrity Measurement Architecture (IMA) supports including
> +fs-verity file digests and signatures in the IMA measurement list
> +and verifying fs-verity based file signatures stored as security.ima
> +xattrs, based on policy.

This looks okay, but this would be easier to understand as a list of alternative
ways to do signature verification with fs-verity:

	* Userspace-only
	* Built-in signature verification + userspace policy
	* IMA

- Eric
