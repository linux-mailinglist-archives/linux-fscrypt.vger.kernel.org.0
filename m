Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA60A4A5470
	for <lists+linux-fscrypt@lfdr.de>; Tue,  1 Feb 2022 02:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbiBABG5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 31 Jan 2022 20:06:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbiBABGy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 31 Jan 2022 20:06:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C453AC061714;
        Mon, 31 Jan 2022 17:06:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6425761269;
        Tue,  1 Feb 2022 01:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2522C340E8;
        Tue,  1 Feb 2022 01:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643677613;
        bh=E43mWM2asqoVBWi92T3m8oMF+9mkvSoQNt6nGdzak+g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AsOzer6xb2lUriSmhK+MXyOqmK+pjcu/TaNAM/0OApnnZ+7B73a4coMrVa+akNSG7
         co1DR+/0Rpq1fAoZkCscjpt8IwCb+sdWx58ChmPNNH04DlICOFyQyu+ipLowZXSXtk
         96VgM9wMBhwp1icVLA5FnYW4byAp41jjAv9QHlyKfzOq7n1VfvqDY8Hczx5H5tE3FD
         QVMedxR9lGpAoNCt316ggLXvYCpKNsoAvMck8ccex0hiXANIH+Erjt1SQ86CdztrO8
         d3G2JIp2Htjkct2Dkp6D0hLT12O2Ci0eqMNsB81ULzpDeL/tFpqroCUUkP9oy1W5T8
         KGWBH31k9xhTg==
Date:   Mon, 31 Jan 2022 17:06:52 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/8] ima: support fs-verity file digest based version
 3 signatures
Message-ID: <YfiHrMU5tOsg5DMi@sol.localdomain>
References: <20220126000658.138345-1-zohar@linux.ibm.com>
 <20220126000658.138345-8-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126000658.138345-8-zohar@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Jan 25, 2022 at 07:06:57PM -0500, Mimi Zohar wrote:
> Instead of calculating a file hash and verifying the signature stored
> in the security.ima xattr against the calculated file hash, verify
> fs-verity's signature (version 3).
> 
> To differentiate between a regular file hash and an fs-verity file digest
> based signature stored as security.ima xattr, define a new signature type
> named IMA_VERITY_DIGSIG.
> 
> Update the 'ima-sig' template field to display the new fs-verity signature
> type as well.
> 
> For example:
>   appraise func=BPRM_CHECK digest_type=hash|verity
> 
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>  Documentation/ABI/testing/ima_policy      | 10 +++++
>  Documentation/security/IMA-templates.rst  |  4 +-
>  security/integrity/ima/ima_appraise.c     | 49 ++++++++++++++++++++++-
>  security/integrity/ima/ima_template_lib.c |  3 +-
>  security/integrity/integrity.h            |  5 ++-
>  5 files changed, 65 insertions(+), 6 deletions(-)

All this IMA-specific stuff is confusing to me, so let me ask a question about
what the end result actually is.  Let's say I want to use IMA to authenticate
("appraise") a file.  I've signed its fs-verity digest with a key.  I put only
that one key in the IMA keyring, and that key was only ever used to sign that
one fs-verity digest.  Can an attacker (who controls the file's contents and IMA
xattr) replace the file with one with a different contents and still pass the
IMA check?  For example, could they replace the file's contents with the
ima_file_id of the authentic file, and then downgrade the signature version to
v2?  If they can do that, then the goal of authentication wasn't met.  It might
be necessary to enforce that only one signature version is used at a time, to
avoid this kind of ambiguity.

- Eric
