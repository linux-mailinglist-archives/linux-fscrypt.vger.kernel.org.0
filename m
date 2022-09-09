Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E68E5B3933
	for <lists+linux-fscrypt@lfdr.de>; Fri,  9 Sep 2022 15:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiIINjg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 9 Sep 2022 09:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiIINjf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 9 Sep 2022 09:39:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030D2654B;
        Fri,  9 Sep 2022 06:39:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B980422BDE;
        Fri,  9 Sep 2022 13:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1662730764;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3puYX/PNCCfRPAdsTlGTbGp5m0xkRzJ0bYx6+JP7KiE=;
        b=yS9rljgxa+lSFe9dB3E4uwMbtBN1So2BCzEwBN0Wqmw/CB7SHr89EfZb9sWEosdTn58i7o
        dURLUPtpaS6CZ6UMhfHAv7kvpDTQHG77nEKuEoEexgQc/MQZOx4gOeH0+fdFv7lbZCw002
        OBK9Zwo25ZWnlBtSAttIuadRIoNBygY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1662730764;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3puYX/PNCCfRPAdsTlGTbGp5m0xkRzJ0bYx6+JP7KiE=;
        b=v/i3b4cAbb5MhG+6MPUzR01i5em597x1pob1SiAcKH2wxspSfSXjDre3a1LMThye86nsY3
        Ya773aJnAmgpgzAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5EDDE139D5;
        Fri,  9 Sep 2022 13:39:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id O75WFgxCG2PzRwAAMHmgww
        (envelope-from <dsterba@suse.cz>); Fri, 09 Sep 2022 13:39:24 +0000
Date:   Fri, 9 Sep 2022 15:34:00 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     David Sterba <dsterba@suse.cz>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>, linux-spdx@vger.kernel.org
Subject: Re: [PATCH v2 10/20] btrfs: factor a fscrypt_name matching method
Message-ID: <20220909133400.GY32411@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <685c8abce7bdb110bc306752314b4fb0e7867290.1662420176.git.sweettea-kernel@dorminy.me>
 <20220909101521.GS32411@twin.jikos.cz>
 <Yxs43SlMqqJ4Fa2h@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yxs43SlMqqJ4Fa2h@infradead.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Sep 09, 2022 at 06:00:13AM -0700, Christoph Hellwig wrote:
> On Fri, Sep 09, 2022 at 12:15:21PM +0200, David Sterba wrote:
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * Copyright (C) 2020 Facebook
> > > + */
> > 
> > Please use only SPDX in new files
> > 
> > https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#Copyright_notices_in_files.2C_SPDX
> 
> The wiki is incorrect.  The SPDX tag deals with the licensing tags
> only.  It is not a replacement for the copyright notice in any way, and
> having been involved with Copyright enforcement I can tell you that
> at least in some jurisdictions Copytight notices absolutely do matter.

I believe you and can update the wiki text so it's more explicit about
the license an copyright.

Otherwise I don't see much point in the copyright notices unless they're
complete list of every person and company that touched that file. With
that we haven't been adding that to new files for some time and I want
to be consistent with that. In each case the patch author was asked to
resubmit without the notice. It worked so far.

If not, either the patch will be respectfully rejected or somebody
else creates the file first and then the patch applied.
