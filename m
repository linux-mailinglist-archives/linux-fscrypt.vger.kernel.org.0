Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBC07CB9E5
	for <lists+linux-fscrypt@lfdr.de>; Tue, 17 Oct 2023 07:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjJQFNS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 17 Oct 2023 01:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjJQFNS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 17 Oct 2023 01:13:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B7EA2;
        Mon, 16 Oct 2023 22:13:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E842FC433C7;
        Tue, 17 Oct 2023 05:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697519596;
        bh=yqdF+dupVrwQkn0deXrx10YlGJAxKNIEgnY0AOt1qhc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ecNeu6IAUqfOrYBb2oBbCuWNapCenBrhe/h1x7yHDk3Ees9sJxriatWj30gGQLXeX
         s6cSHIwpIMOqyJoJ4MHK33AdBgiayBHoY44Kk2PcCg6+mEJEr1DNDBmxrMwiMxwAPI
         OsKVu1JuCVbFLMwvfejv7C+WmucVWvPIjoikhSyXUurd6ViQ4J1PJSWpsNYQVevL4X
         B0NCg2JjqppwE6dORA5L3/NrOYAN1vClppH0xhDIlNXp7xvrzoLYKAu3M+3lYSGcKr
         435lOxyNgqanFcLJhUNo+duq/qmaT8zetD8Ou+wmmEsoDwR5N5EfJ/G2bGcjbJuPHm
         Y7iks3pkQMIhA==
Date:   Mon, 16 Oct 2023 22:13:13 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fscrypt: track master key presence separately from secret
Message-ID: <20231017051313.GD1907@sol.localdomain>
References: <20231015061055.62673-1-ebiggers@kernel.org>
 <20231016182337.GA2339326@perftesting>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231016182337.GA2339326@perftesting>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Oct 16, 2023 at 02:23:37PM -0400, Josef Bacik wrote:
> On Sat, Oct 14, 2023 at 11:10:55PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Master keys can be in one of three states: present, incompletely
> > removed, and absent (as per FSCRYPT_KEY_STATUS_* used in the UAPI).
> > Currently, the way that "present" is distinguished from "incompletely
> > removed" internally is by whether ->mk_secret exists or not.
> > 
> > With extent-based encryption, it will be necessary to allow per-extent
> > keys to be derived while the master key is incompletely removed, so that
> > I/O on open files will reliably continue working after removal of the
> > key has been initiated.  (We could allow I/O to sometimes fail in that
> > case, but that seems problematic for reasons such as writes getting
> > silently thrown away and diverging from the existing fscrypt semantics.)
> > Therefore, when the filesystem is using extent-based encryption,
> > ->mk_secret can't be wiped when the key becomes incompletely removed.
> > 
> > As a prerequisite for doing that, this patch makes the "present" state
> > be tracked using a new field, ->mk_present.  No behavior is changed yet.
> > 
> > The basic idea here is borrowed from Josef Bacik's patch
> > "fscrypt: use a flag to indicate that the master key is being evicted"
> > (https://lore.kernel.org/r/e86c16dddc049ff065f877d793ad773e4c6bfad9.1696970227.git.josef@toxicpanda.com).
> > I reimplemented it using a "present" bool instead of an "evicted" flag,
> > fixed a couple bugs, and tried to update everything to be consistent.
> > 
> > Note: I considered adding a ->mk_status field instead, holding one of
> > FSCRYPT_KEY_STATUS_*.  At first that seemed nice, but it ended up being
> > more complex (despite simplifying FS_IOC_GET_ENCRYPTION_KEY_STATUS),
> > since it would have introduced redundancy and had weird locking rules.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Based my fscrypt patches ontop of this one, ran tests with both btrfs and ext4
> with it applied, in addition to my normal review stuff.  You can add
> 
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
> 

Thanks.  I went ahead and applied this patch to the fscrypt tree.

- Eric
