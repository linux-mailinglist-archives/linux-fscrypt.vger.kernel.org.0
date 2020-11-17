Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7DD2B6AB0
	for <lists+linux-fscrypt@lfdr.de>; Tue, 17 Nov 2020 17:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgKQQxQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 17 Nov 2020 11:53:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:40390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbgKQQxQ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 17 Nov 2020 11:53:16 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 705E422447;
        Tue, 17 Nov 2020 16:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605631995;
        bh=xiNBS6ziLfLJGZHE8XyWAeV26fdPG02BxqDAflsxRIo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eTDIw16vyMgDWghO7BCZaQqjCBH42xwMQ3bkcexqWBMkWJjw4wsGQRmCQ0Xy79BRf
         qwyAePHiRHj+8lyRj66gZee/jfpcSIPeTj8dRfdZwAvtOcKpSKM1nciGYWf8jSGOrq
         Vpc6inhUvRRtBEEWqaHa4umGkgDdl7d4Upwa6LfI=
Date:   Tue, 17 Nov 2020 08:53:13 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Luca Boccassi <luca.boccassi@gmail.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [fsverity-utils PATCH v2 0/4] Add libfsverity_enable() and
 default params
Message-ID: <X7P/+UFX/6hSzSIc@sol.localdomain>
References: <20201116205628.262173-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116205628.262173-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Nov 16, 2020 at 12:56:24PM -0800, Eric Biggers wrote:
> This patchset adds wrappers around FS_IOC_ENABLE_VERITY to libfsverity,
> makes libfsverity (rather than just the fsverity program) default to
> SHA-256 and 4096-byte blocks, and makes the fsverity commands share code
> to parse the libfsverity_merkle_tree_params.
> 
> This is my proposed alternative to Luca's patch
> https://lkml.kernel.org/linux-fscrypt/20201113143527.1097499-1-luca.boccassi@gmail.com
> 
> Changed since v1:
>   - Moved the default hash algorithm and block size handling into
>     libfsverity.
> 
> Eric Biggers (4):
>   programs/fsverity: change default block size from PAGE_SIZE to 4096
>   lib/compute_digest: add default hash_algorithm and block_size
>   lib: add libfsverity_enable() and libfsverity_enable_with_sig()
>   programs/fsverity: share code to parse tree parameters
> 

All applied.

- Eric
