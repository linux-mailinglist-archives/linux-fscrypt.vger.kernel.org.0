Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B24598A94
	for <lists+linux-fscrypt@lfdr.de>; Thu, 18 Aug 2022 19:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238780AbiHRRiJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 18 Aug 2022 13:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234631AbiHRRiI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 18 Aug 2022 13:38:08 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7AAC6B41;
        Thu, 18 Aug 2022 10:38:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A26005C1C7;
        Thu, 18 Aug 2022 17:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660844285;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rYY6flJGyotgT5Be8P49wQ+dgbhi+ny7o+VMDAtJSbo=;
        b=hse+p8lkCD38rt9lw5CITanuwJircpiHMIW7v5z/8vSzFe6LKYhSnsmcHub3SNa7rte8O3
        ztFJwQnQpCnlIyQ3nQvCRXAA+fBZI12o20MjsHeLJw1o1p6ACnnBXr+mfyYXtk4sILOhih
        bEv6YdoXk4T+KP7ItY7jgMh+iBpjNEE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660844285;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rYY6flJGyotgT5Be8P49wQ+dgbhi+ny7o+VMDAtJSbo=;
        b=Vp7IdG4Q+SpXRK5Flba/NK+xCdtaEjp+fH5zpN6shL7ehUm3oATxN6zpzoqnIFdA+IRmSh
        HtlRnIsZCcdsGxDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7DBFE133B5;
        Thu, 18 Aug 2022 17:38:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /BLGHf14/mJnRwAAMHmgww
        (envelope-from <dsterba@suse.cz>); Thu, 18 Aug 2022 17:38:05 +0000
Date:   Thu, 18 Aug 2022 19:32:54 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v4] btrfs: send: add support for fs-verity
Message-ID: <20220818173254.GN13489@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Boris Burkov <boris@bur.io>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
References: <0561e8a33f991fa15053054b7b089d176fde6523.1660596577.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0561e8a33f991fa15053054b7b089d176fde6523.1660596577.git.boris@bur.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Aug 15, 2022 at 01:54:28PM -0700, Boris Burkov wrote:
> Preserve the fs-verity status of a btrfs file across send/recv.
> 
> There is no facility for installing the Merkle tree contents directly on
> the receiving filesystem, so we package up the parameters used to enable
> verity found in the verity descriptor. This gives the receive side
> enough information to properly enable verity again. Note that this means
> that receive will have to re-compute the whole Merkle tree, similar to
> how compression worked before encoded_write.
> 
> Since the file becomes read-only after verity is enabled, it is
> important that verity is added to the send stream after any file writes.
> Therefore, when we process a verity item, merely note that it happened,
> then actually create the command in the send stream during
> 'finish_inode_if_needed'.
> 
> This also creates V3 of the send stream format, without any format
> changes besides adding the new commands and attributes.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>

As for the merge target, a realistic one seems to be 6.2, we have too
many pending patches everywhere else. There's a todo list for v3 that
I'd really like to get done.

To be able to test things incrementally until then we can add v3 support
under debug config.

> --
> Changes in v4:
> - Use btrfs_get_verity_descriptor instead of verity ops get descriptor.
>   Move that definition to ctree.h for conditional building. This cleaned
>   up most of the conditional building issues, in my opinion.

Yes, that way it's ok.

> - Rename process_new_verity to process_verity.
> - Use le-to-cpu conversion for all fsverity descriptor fields.
> - Don't check NULL for kvfree of the send descriptor.

> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -3,6 +3,7 @@
>   * Copyright (C) 2012 Alexander Block.  All rights reserved.
>   */
>  
> +#include "linux/compiler_attributes.h"

As Eric pointed out, this is not necessary, I'll delete the line, no
need to resend just for that.
