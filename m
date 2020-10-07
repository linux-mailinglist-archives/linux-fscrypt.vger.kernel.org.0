Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D42D286A5A
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Oct 2020 23:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgJGVjm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 7 Oct 2020 17:39:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbgJGVjm (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 7 Oct 2020 17:39:42 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C8E22083B;
        Wed,  7 Oct 2020 21:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602106781;
        bh=sdRxveUhVytWLRhWGk462Ot+awyuVxCG/A90yWYdq/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MzfvFlFTY4ZrVPRXDn5j7jg6BP43NEwJHSuM+ziF4i9UzTd0CUmg6a1FZG6vyxBgy
         X9JDRAyds9tGyNTwoGhmEynUgxanc6PpEUUibSiTAK4G8D4fyCxFidES9jbrWA/ZbP
         Xl/Pe7ev1K+G4GGmGVFyXCzbuwSPkmj27S44yGac=
Date:   Wed, 7 Oct 2020 14:39:40 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 0/1] userspace support for F2FS metadata encryption
Message-ID: <20201007213940.GE1530638@gmail.com>
References: <20201005074133.1958633-1-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005074133.1958633-1-satyat@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Oct 05, 2020 at 07:41:32AM +0000, Satya Tangirala wrote:
> The kernel patches for F2FS metadata encryption are at:
> 
> https://lore.kernel.org/linux-fscrypt/20201005073606.1949772-4-satyat@google.com/
> 
> This patch implements the userspace changes required for metadata
> encryption support as implemented in the kernel changes above. All blocks
> in the filesystem are encrypted with the user provided metadata encryption
> key except for the superblock (and its redundant copy). The DUN for a block
> is its offset from the start of the filesystem.
> 
> This patch introduces two new options for the userspace tools: '-A' to
> specify the encryption algorithm, and '-M' to specify the encryption key.
> mkfs.f2fs will store the encryption algorithm used for metadata encryption
> in the superblock itself, so '-A' is only applicable to mkfs.f2fs. The rest
> of the tools only take the '-M' option, and will obtain the encryption
> algorithm from the superblock of the FS.

As I mentioned on the kernel patches, it might make sense to compute a
metadata_key_identifier and store it in the super_block so that it can be
automatically requested without needing to provide an option.

> 
> Limitations: 
> Metadata encryption with sparse storage has not been implemented yet in
> this patch.
> 
> This patch requires the metadata encryption key to be readable from
> userspace, and does not ensure that it is zeroed before the program exits
> for any reason.
> 
> Satya Tangirala (1):
>   f2fs-tools: Introduce metadata encryption support

A cover letter shouldn't be used for a 1-patch series.  Just include these
details in the patch instead.

- Eric
