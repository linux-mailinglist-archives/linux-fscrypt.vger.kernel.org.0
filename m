Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D63B746204
	for <lists+linux-fscrypt@lfdr.de>; Mon,  3 Jul 2023 20:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjGCSSH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 3 Jul 2023 14:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbjGCSSA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 3 Jul 2023 14:18:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091BEE7B;
        Mon,  3 Jul 2023 11:17:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E17360FFA;
        Mon,  3 Jul 2023 18:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CD5C433B6;
        Mon,  3 Jul 2023 18:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688408267;
        bh=sBldOHY8a4ZzImsYL/nhz6KIWddC3eep2b5bUsDNZzc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=miDHwhKOlbGRk1FLlOr/UJ3/YpCSttl7ho255/73r6PItipNY5/DS/XxCykMZA4mE
         OTa0qye8+o/rWkMbGEn7dYoxmeXv9E1pDZbTB0luA6TXHTRO0hXojAEeuEk8TILFHl
         3aKm4Oz7HrY4vs4klWWwprckyWu36+twPPet7OU3YvKfkwXpmAOBupLiohOW/UZ8zo
         RaPTsqlkLBqPScAIFHoT0K4dZfPMy1L+3gjj8qSb3CL72jAWKyU0O98cLFa7yAxYQi
         crn+b7+IWLCQhq2bi+kxJTwIckyLppBXHJFNBMvMTlBx5jVBcWGHntC5cd+KRzWj6p
         PeMVNBfCPzwVQ==
Date:   Mon, 3 Jul 2023 11:17:45 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v1 00/12] fscrypt: add extent encryption
Message-ID: <20230703181745.GA1194@sol.localdomain>
References: <cover.1687988246.git.sweettea-kernel@dorminy.me>
 <20230703045417.GA3057@sol.localdomain>
 <712d5490-8f36-f41d-4488-91e86e694cad@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <712d5490-8f36-f41d-4488-91e86e694cad@dorminy.me>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jul 03, 2023 at 01:06:17PM -0400, Sweet Tea Dorminy wrote:
> > 
> > I think that would avoid many of the problems that it seems you've had to work
> > around or have had to change user-visible semantics for.  For example the
> > problems involving master keys being added and removed.  It would also avoid
> > having to overload 'fscrypt_info' to be either a per-inode or a per-extent key.
> > And it would save space on disk and in memory.
> 
> I might be misunderstanding what you're referencing, but I think you're
> talking about the change where with extent fscrypt, IO has to be forced down
> before removing a key, otherwise it is lost. I think that's a fundamental
> problem given the filesystem has no way to know that there are new, dirty
> pages in the pagecache until those pages are issued for write, so it can't
> create a new extent or few until that point, potentially after the relevant
> key has been evicted. But maybe I'm missing a hook that would let us make
> extents earlier.
> 
> I suppose we could give each leaf inode a proper nonce/prepared key instead
> of borrowing its parent dir's: if a write came in after the key was removed
> but the inode is still open, the new extent(s) could grab the key material
> out of the inode's info. I don't like this very much since it could result
> in multiple extents grabbing the same key material, but I suppose it could
> work if it's important to maintain that behavior.

Right, if extent keys are derived directly from the master key, and
FS_IOC_REMOVE_ENCRYPTION_KEY is executed which causes the master key secret to
be wiped, then no more extent keys can be derived.

So I see why you implemented the behavior you did.  It does seem a bit
dangerous, though.  If I understand correctly, under your proposal, if
FS_IOC_REMOVE_ENCRYPTION_KEY is executed while a process is doing buffered
writes to an encrypted file protected by that key, then past writes will get
synced out just before the key removal, but future writes will just be silently
thrown away.  (Remember, writes in Linux are asynchronous; processes don't get
informed of write errors unless they call fsync() or are doing direct I/O.)

I wonder if we should just keep the master key around, for per-extent key
derivation only, until all files using that master key have been closed.  That
would minimize the changes from the current fscrypt semantics.

> > Can you elaborate on why you went with a more "heavyweight" extents design?
> Being able to rekey a directory is the reason for having full contexts:
> suppose I take a snapshot of an encrypted dir and want to change the key for
> new data going forward, to avoid using a single key on too much data. It's
> too expensive to reencrypt every extent with the new key, since the whole
> point of a snapshot is to make a lightweight copy that gets COWed on write.
> Then each extent needs to know what its own master key
> identifier/policy/flags are, since different extents in the same file could
> have different master keys. We could say the mode and flags have to match,
> but it doesn't seem to me worth saving seven bytes to add a new structure to
> just store the master key identifier and nonce.
> 
> For a non-Meta usecase, from what I've heard from Fedora-land, it's possibly
> interesting to them to be able to ship an encrypted image, and then be able
> to change the key after encrypted install to something user-controlled.
> 
> Without rekeying, my understanding is that we may write too much data with
> one key for safety; notes in the updated design doc https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7iDaCDQQNZA/edit?usp=sharing
> are that writing more than 1P per key raises cryptographic concerns, and
> since btrfs is COW and could have volumes up to the full 16E size that btrfs
> supports, we don't want to have just one immutable key per subvol.
> 
> To me the lightweight-on-disk vision sounds a lot like the original design:
> https://lore.kernel.org/linux-btrfs/YXGyq+buM79A1S0L@relinquished.localdomain
> and the Nov '22 version of the patchset: https://lore.kernel.org/linux-btrfs/cover.1667389115.git.sweettea-kernel@dorminy.me/
> (which didn't have rekeying). I think rekeying is worth the higher disk
> usage; but I'm probably missing something about how your vision differs from
> the original. Could you please take a look at it again?

Your original design didn't use per-extent keys, but rather had a single
contents encryption key per master key.  We had discussed that that approach had
multiple disadvantages, one of which is that on btrfs it can run uncomfortably
close to the cryptographic limits for the contents encryption modes such as
AES-XTS.  So we decided to go with per-extent keys instead.

I don't think we discussed cryptographic limits on the master key itself.  That
is actually much less of a concern, as the master key is just used for
HKDF-SHA512.  I don't think there is any real need to ever change the master
key.  (Well, if it is compromised, it could be needed, but that's not really
relevant here.  If that happens you'd need to re-encrypt everything anyway.)

I do recall some discussion of making it possible to set an encryption policy on
an *unencrypted* directory, causing new files in that directory to be encrypted.
However, I don't recall any discussion of making it possible to add another
encryption policy to an *already-encrypted* directory.  I think this is the
first time this has been brought up.

I think that allowing directories to have multiple encryption policies would
bring in a lot of complexity.  How would it be configured, and what would the
semantics for accessing it be?  Where would the encryption policies be stored?
What if you have added some of the keys but not all of them?  What if some of
the keys get removed but not all of them?

Can you elaborate more on why you want this?  I was already a bit concerned
about the plan for making it possible to set an encryption policy on an
unencrypted directory, as that already diverges from the existing fscrypt
semantics.  But now it sounds like the scope has grown even more.

Keep in mind that in general, the closer we are able to stick to the existing
fscrypt semantics and design, the easier it is going to be to get the initial
btrfs fscrypt support merged.  Planning ahead for new features is good, but we
should also be careful not to overdesign.

- Eric
