Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64DB55B34D7
	for <lists+linux-fscrypt@lfdr.de>; Fri,  9 Sep 2022 12:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiIIKKQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 9 Sep 2022 06:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiIIKKM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 9 Sep 2022 06:10:12 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FD86D57D;
        Fri,  9 Sep 2022 03:10:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EB65222BBE;
        Fri,  9 Sep 2022 10:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1662718207;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bB0HwRzorQq3QyAw373+JtdTD22NMoDYiml1+Rr0F0U=;
        b=i+IofYGBTpBruwZMa3BqMoxk+lQG5BF8S6no6GHmClsq0WjxPDr3jPMLbc7mv0Hax/aGdC
        H3Uy/FVhe1m0LGCPzoqsKhkj5tCOOW0wVgl7a1XSvCCot9z+yapol4okoAl0OgZaDDk+Xo
        nGZtOLC3Pg5n1+D8qcvFyq/Vc5WOCLs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1662718207;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bB0HwRzorQq3QyAw373+JtdTD22NMoDYiml1+Rr0F0U=;
        b=HEWsBJbaVYoK32zwhUzUO8Cp1PWl2eddS1R6YAU1UtqLfUu/NGH4o9x3KYa+m1aCxFEC8Y
        MbWar7rhpSPyTKDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B014A13A93;
        Fri,  9 Sep 2022 10:10:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xcAJKv8QG2OScQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Fri, 09 Sep 2022 10:10:07 +0000
Date:   Fri, 9 Sep 2022 12:04:43 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 15/20] btrfs: store a fscrypt extent context per
 normal file extent
Message-ID: <20220909100443.GR32411@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <460baa45489be139b48e7b152852bda919363b4c.1662420176.git.sweettea-kernel@dorminy.me>
 <20220907211053.GM32411@twin.jikos.cz>
 <0b06375915f5ef9529682e2d71dce6bd@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b06375915f5ef9529682e2d71dce6bd@dorminy.me>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Sep 07, 2022 at 05:39:04PM -0400, Sweet Tea Dorminy wrote:
> 
> > FSCRYPT_EXTENT_CONTEXT_MAX_SIZE is 33 and btrfs_fscrypt_extent_context
> > is part of extent_map, that's quite common object. Random sample from 
> > my
> > desktop right now is around 800k objects so this is noticeable. Needs a
> > second look.
> > 
> >> +
> >>  extern const struct fscrypt_operations btrfs_fscrypt_ops;
> >>  #endif /* BTRFS_FSCRYPT_H */
> >> --- a/fs/btrfs/ordered-data.h
> >> +++ b/fs/btrfs/ordered-data.h
> >> @@ -99,6 +99,7 @@ struct btrfs_ordered_extent {
> >>  	u64 disk_bytenr;
> >>  	u64 disk_num_bytes;
> >>  	u64 offset;
> >> +	struct btrfs_fscrypt_extent_context fscrypt_context;
> > 
> > And another embedded btrfs_fscrypt_extent_context, that can also get a
> > lot of slab objects.
> 
> I could certainly define fscrypt_extent_context's as a separate btree 
> object type, and/or have them be separately allocated and just have a 
> pointer in the various structures to keep track of them. I didn't have a 
> separate object for them since its only a 17 or 33 byte object (at 
> present) on a per-btrfs_file_extent basis, but maybe that would be 
> better?

btrfs_ordered_extent is in memory so I don't know what you mean by a
btree object here, that's used for on-disk structures. All the new
fscrypt code adds a lot of stack space and increases data structures but
that's something that needs to be effectively, so if the pointers can be
shared then please find a way. I still don't have the whole picture so
can't say what would be best, there are still other things to address so
once that's done we can focus on the memory consumption. You can keep it
as is for now but keep notes that it needs another look later.

> I could also #ifdef CONFIG_FS_ENCRYPTION the member in each structure, 
> if that would help over and beyond either of the previous things.

I think all the fscrypt related code should be behind ifdef
CONFIG_FS_ENCRYPTION, so the struct members too.
