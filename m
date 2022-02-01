Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D5D4A5451
	for <lists+linux-fscrypt@lfdr.de>; Tue,  1 Feb 2022 01:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbiBAA4g (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 31 Jan 2022 19:56:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39330 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiBAA4g (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 31 Jan 2022 19:56:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5524361180;
        Tue,  1 Feb 2022 00:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99279C340E8;
        Tue,  1 Feb 2022 00:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643676995;
        bh=rYNlss3eka1Q3HQyjKmRt1eCt6GjTaULeioT0xHXIYw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rP3RtIMmYgtn++eIvZpCElRLfCBoY0T9cWCWnM+4mHNxpkAhNWDJty3eMWe3RcUQo
         rwt7DHuJQFWrM0eLjhs1arr+C7JpUueh+/S0md3boUr5hTxD5QapCMnxNz15Ir3imK
         ne5Ze3xb2UL/XjtfCSfCqaH1sbqUpDOqA1M11ALBCAGASzfUbkg1CK0PN/ijXokvk5
         Gr5iiw8e3RYyQF3ItAS1E9wqgEultnmj7Z6yCAf+PO38xZuBalP03BI2DVT7fsR4ld
         wyR2SgM5Ti6YqWMjnkg7I9q10xAS5YLin1/hFXyCVVXDhVDieCfPjofNpu/Wb3Ex5t
         dLFJpercGIFqQ==
Date:   Mon, 31 Jan 2022 16:56:34 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/8] ima: include fsverity's file digests in the IMA
 measurement list
Message-ID: <YfiFQr3OhDij11A3@sol.localdomain>
References: <20220126000658.138345-1-zohar@linux.ibm.com>
 <20220126000658.138345-6-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126000658.138345-6-zohar@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Jan 25, 2022 at 07:06:55PM -0500, Mimi Zohar wrote:
> Allow fsverity's file digests to be included in the IMA measurement list
> based on policy.
> 
> Define a new measurement policy rule option named 'digest_type=' to
> allow fsverity file digests to be included in the measurement list
> in the d-ng field.
> 
> Including the 'd-type' template field is recommended for unsigned
> fs-verity digests to distinguish between d-ng digest types.  The
> following policy rule, for example, specifies the new 'ima-ngv2'
> template.
> 
> measure func=FILE_CHECK digest_type=hash|verity template=ima-ngv2
> 
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>  Documentation/ABI/testing/ima_policy      |  7 +++++
>  Documentation/security/IMA-templates.rst  |  6 ++++
>  security/integrity/ima/ima_api.c          | 29 +++++++++++++++--
>  security/integrity/ima/ima_policy.c       | 38 ++++++++++++++++++++++-
>  security/integrity/ima/ima_template_lib.c |  9 +++++-
>  security/integrity/integrity.h            |  4 ++-
>  6 files changed, 88 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
> index 839fab811b18..444bb7ccbe03 100644
> --- a/Documentation/ABI/testing/ima_policy
> +++ b/Documentation/ABI/testing/ima_policy
> @@ -51,6 +51,7 @@ Description:
>  			appraise_flag:= [check_blacklist]
>  			Currently, blacklist check is only for files signed with appended
>  			signature.
> +			digest_type:= [hash|verity]

This doesn't explain what this option actually does.

> diff --git a/Documentation/security/IMA-templates.rst b/Documentation/security/IMA-templates.rst
> index 1a91d92950a7..5e31513e8ec4 100644
> --- a/Documentation/security/IMA-templates.rst
> +++ b/Documentation/security/IMA-templates.rst
> @@ -69,6 +69,7 @@ descriptors by adding their identifier to the format string
>     algorithm (field format: [<hash algo>:]digest, where the digest
>     prefix is shown only if the hash algorithm is not SHA1 or MD5);
>   - 'd-modsig': the digest of the event without the appended modsig;
> + - 'd-type': the type of file digest (e.g. hash, verity[1]);

This should explain how this is different from the hash algorithm.

- Eric
