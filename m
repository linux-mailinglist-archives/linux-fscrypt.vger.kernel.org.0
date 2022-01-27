Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F9249EB21
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Jan 2022 20:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbiA0TfQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 27 Jan 2022 14:35:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34070 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiA0TfP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 27 Jan 2022 14:35:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 323BE61DE7;
        Thu, 27 Jan 2022 19:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6163DC340E4;
        Thu, 27 Jan 2022 19:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643312114;
        bh=xjDuYL44PRCV60j88JUn8U44NjVGqHmowB7jXW8PlMI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kDW9jvfe+ZIWLeUMcHMbmxdnXkNwekVDfxS9Gr0DxQ6wXjSlKJW7sjpxdHC6OJt3q
         neuKfJiXNSECbbY/rnCUQtwXWcewcrWs73g3d26OiVEiVeUl50e2vrT7I728SfQHJm
         0smyF1GeLHct7C/yBKONgSL2Kn+hHLWiQRhLz7YJVkxZGv0fCFlwv85L/3qCfPk1nl
         cyrSLUs9MaGNwmMfCJxVcXFHYnTFHa88pc0982KDz4YUt6ZYBdAiAMyvWmgMd6ACcK
         JzAwkOuhaJy9DA4mu5Jj1huUxgeZckEMTC4m5n7LvEdFlslZ3Viblsu1WIH7tcy1gu
         VjmFrf7Yoka6w==
Date:   Thu, 27 Jan 2022 11:35:12 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     linux-integrity@vger.kernel.org, zohar@linux.ibm.com,
        stefanb@linux.ibm.com, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH v3a 00/11] ima: support fs-verity digests and
 signatures (alternative)
Message-ID: <YfLz8NftvbZtKvLT@sol.localdomain>
References: <20220127184614.2837938-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127184614.2837938-1-roberto.sassu@huawei.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jan 27, 2022 at 07:46:09PM +0100, Roberto Sassu wrote:
> I wanted to propose a different approach for handling fsverity digests and
> signatures, compared to:
> 
> https://lore.kernel.org/linux-integrity/20220126000658.138345-1-zohar@linux.ibm.com/
> 
> In the original proposal, a new signature version has been introduced (v3)
> to allow the possibility of signing the digest of a more flexible data
> structure, ima_file_id, which could also include the fsverity file digest.
> 
> While the new signature type would be sufficient to handle fsverity file
> digests, the problem is that its format would not be compatible with the
> signature format supported by the built-in verification module in fsverity.
> The rpm package manager already has an extension to include fsverity
> signatures, with the existing format, in the RPM header.
> 
> Given that the fsverity signature is in the PKCS#7 format, IMA has already
> the capability of handling it with the existing code, more specifically the
> modsig code. It would be sufficient to provide to modsig the correct data
> to avoid introducing a new signature format.

I think it would be best to get people moved off of the fs-verity built-in
signatures, rather than further extend the use of it.  PKCS#7 is a pretty
terrible signature format.  The IMA one is better, though it's unfortunate that
IMA still relies on X.509 for keys.

- Eric
