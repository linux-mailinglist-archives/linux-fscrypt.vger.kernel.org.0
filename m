Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2C4587E85
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Aug 2022 17:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237349AbiHBPD6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 2 Aug 2022 11:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234433AbiHBPD5 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 2 Aug 2022 11:03:57 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1C5237FC;
        Tue,  2 Aug 2022 08:03:56 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DFE633420E;
        Tue,  2 Aug 2022 15:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1659452633;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T/ylml1TMopPsWGf4bCgFH549wn8Z8dEYpYkupfsQcc=;
        b=pcG1Mgc54lCdeZ0rwzc14HFQ0bkpBgWRazOrhWYX6mXOdrG9o6GRYqI/iGLnzNNVBlldX2
        j0eNeFKMrqLBP9wsZ7xejKCXGKwRz6JhjSVLqVHhjzOHKaFthpiLzzbk9+H5bsbBTfQ0IG
        vAflZ7uiyg4H/gM8PAnIFDg5N9j2DCs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1659452633;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T/ylml1TMopPsWGf4bCgFH549wn8Z8dEYpYkupfsQcc=;
        b=NTKFJXzJ3BRiSe5Sj8rp+bHiR7RGCa1vRVHyKhHdU6e+tMMYYQMVIHSGBnOhvH3YflyBCS
        ivKv74qb0U37H+Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BF97D13A8E;
        Tue,  2 Aug 2022 15:03:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8JniLdk86WK3BgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Tue, 02 Aug 2022 15:03:53 +0000
Date:   Tue, 2 Aug 2022 16:58:52 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v2] btrfs: send: add support for fs-verity
Message-ID: <20220802145852.GP13489@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Boris Burkov <boris@bur.io>,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <9bfbf3b43d2c2663d2e3f196810288fd83c0b52e.1659031503.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bfbf3b43d2c2663d2e3f196810288fd83c0b52e.1659031503.git.boris@bur.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_SOFTFAIL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jul 28, 2022 at 11:11:42AM -0700, Boris Burkov wrote:
> --- a/fs/btrfs/send.h
> +++ b/fs/btrfs/send.h
> @@ -92,8 +92,11 @@ enum btrfs_send_cmd {
>  	BTRFS_SEND_C_ENCODED_WRITE	= 25,
>  	BTRFS_SEND_C_MAX_V2		= 25,
>  
> +	/* Version 3 */
> +	BTRFS_SEND_C_ENABLE_VERITY	= 26,

Regarding the name, same name for ioctl and command is a good idea, for
potential future verity extensions we could add more and having plain
'VERITY' would not be ideal. The other ioctl is 'measure', so I thought
of something like consistency check during the stream, "verify this
file before continuing".

The command names are either imperative or descriptive, so alternative
name could be VERITY_RECORD or VERITY_DESC that matches the data stored,
the BTRFS_VERITY_DESC_ITEM_KEY .
