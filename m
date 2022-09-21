Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 037FD5C0003
	for <lists+linux-fscrypt@lfdr.de>; Wed, 21 Sep 2022 16:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiIUOhH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 21 Sep 2022 10:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiIUOhG (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 21 Sep 2022 10:37:06 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10AF895E2;
        Wed, 21 Sep 2022 07:37:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6F0AA21AFB;
        Wed, 21 Sep 2022 14:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1663771024;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ycfNx7lxd8IxkDqAgx5vrVmIUDuybULS8jkYBcbya4E=;
        b=fweMIn9b/AK3xlulXmxVOJmxG6ScMiXz2LV3MyLc8L8k5opLdamBVp6ayB3+yS9iYt6hIc
        oyM8qE3/aKRbDWeyI99D9n1KzE3W1XWrf19rDD4UibbsrF4riMz+IW+JalvJaGd/HhEk9u
        1Ht1HPfy3H+IR/+NknWEvQwxHl8MVnE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1663771024;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ycfNx7lxd8IxkDqAgx5vrVmIUDuybULS8jkYBcbya4E=;
        b=MJAN6B+Fi76eIo+l0W0EnBsLrHOfGC3QBxECWP9hAdiBrTVxinAyQyyV0WBCA7cuP9MJwx
        nc2EzlgTzSSOr0DQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3DBC913A89;
        Wed, 21 Sep 2022 14:37:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IMQCDpAhK2NUWgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 21 Sep 2022 14:37:04 +0000
Date:   Wed, 21 Sep 2022 16:31:32 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v3] btrfs-progs: receive: add support for fs-verity
Message-ID: <20220921143132.GH32411@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <3cf3573328789fcacb968f7707dc6839e44043f9.1660595824.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cf3573328789fcacb968f7707dc6839e44043f9.1660595824.git.boris@bur.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Aug 15, 2022 at 01:54:42PM -0700, Boris Burkov wrote:
> Process an enable_verity cmd by running the enable verity ioctl on the
> file. Since enabling verity denies write access to the file, it is
> important that we don't have any open write file descriptors.
> 
> This also revs the send stream format to version 3 with no format
> changes besides the new commands and attributes.
> 
> Note: the build is conditional on the header linux/fsverity.h
> 
> Signed-off-by: Boris Burkov <boris@bur.io>

Added to devel, thanks. The v3 is still in the works and unstable so we
need to keep both sides in sync. I've added a line to configure summary
and added a line to 'btrfs receive --help' if it's compiled in.

We may also want to add an option to receive to skip verity records so
the stream can be received but without them, but that's for future once
we'll start with v3 again.
