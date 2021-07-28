Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2CB3D9186
	for <lists+linux-fscrypt@lfdr.de>; Wed, 28 Jul 2021 17:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235686AbhG1PJB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jul 2021 11:09:01 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:34486 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235555AbhG1PIb (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jul 2021 11:08:31 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 1FFB11FFCA;
        Wed, 28 Jul 2021 15:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1627484903;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KPyulSuVaRXPc6wZQ9/NB4dHFx9au56dn1uHMemRujE=;
        b=eX4leyh+KIUmf58xAPBSwapMyPMTMmXiwdE7+GrqWK27exHJ8VL7SU82ilAcazn5bbQ1OP
        tL9pRhoFdCBQn/kY9PvJ/eP3rQmUqn4quGiSQ+Av9sSk/jHmBYhWBGjxlxFTDprZu+yUt7
        IrNW2RB0lRiagLvLjbeQSUoGX2ziL08=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1627484903;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KPyulSuVaRXPc6wZQ9/NB4dHFx9au56dn1uHMemRujE=;
        b=ucc6K+nKKkX8wGmesy9+TlENF8merC9CufOrdIDunkIDLKrH8Ojasm6cJfbQ/3AYyq3Zkm
        t6T5kRus5QR6GKDQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 1828AA3B83;
        Wed, 28 Jul 2021 15:08:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 307B2DA8A7; Wed, 28 Jul 2021 17:05:38 +0200 (CEST)
Date:   Wed, 28 Jul 2021 17:05:38 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v6 2/3] btrfs: initial fsverity support
Message-ID: <20210728150537.GL5047@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Boris Burkov <boris@bur.io>,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
References: <cover.1625083099.git.boris@bur.io>
 <797d6524e4e6386fc343cd5d0bcdd53878a6593e.1625083099.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <797d6524e4e6386fc343cd5d0bcdd53878a6593e.1625083099.git.boris@bur.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jun 30, 2021 at 01:01:49PM -0700, Boris Burkov wrote:
> +struct btrfs_verity_descriptor_item {
> +	/* size of the verity descriptor in bytes */
> +	__le64 size;
> +	/*
> +	 * When we implement support for fscrypt, we will need to encrypt the
> +	 * Merkle tree for encrypted verity files. These 128 bits are for the
> +	 * eventual storage of an fscrypt initialization vector.
> +	 */
> +	__le64 reserved[2];

This does 2 for known extensions, do you think more would be desirable?
Eg. reserving 256 bits. We can detect that also at runtime by the item
size so it's extensible but just in case this could be done from the
beginning.

> +	__u8 encryption;
> +} __attribute__ ((__packed__));
> +
>  #endif /* _BTRFS_CTREE_H_ */
> -- 
> 2.31.1
