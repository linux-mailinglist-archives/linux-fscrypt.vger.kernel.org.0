Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4FC6748935
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 Jul 2023 18:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbjGEQ2N (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 5 Jul 2023 12:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbjGEQ2N (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 5 Jul 2023 12:28:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77591700;
        Wed,  5 Jul 2023 09:28:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23EB161342;
        Wed,  5 Jul 2023 16:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E9EC433C9;
        Wed,  5 Jul 2023 16:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688574490;
        bh=L3rafJpmC3wFquLDVrSYplEXgfMendTWJbrTMS2PS04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FvXkwP+E/vescmU4XmUcC0Ah3sTDN2Nlt0FWY+/EsE/Ffmyt8eRDXmlpKE7639h1p
         LugHQdDgBPqVZfXYNZFZ39LZWsVJRo3BZpXjaqWPmNW54nALRHhyqYda9Q4gRJXXso
         gjV6SW4rmALnLB9BitiuMX9ze5hN7VFbnXGkvQFSnFm/Cm4BzNWUE+sOG62OuiBgcg
         8RxhpJW4kgjxKLzeLED10MgbQ0gX4COccMA3ofW5vXm4PPIXZiZg2KWN3TRzHX0BMW
         5O6J/3TJJBultP+5xW7joOhoxuLTa9aASYtLQriX19AIRFpVV9DEEfv1DBmU0DHVPS
         fV6W/+YqpqPOA==
Date:   Wed, 5 Jul 2023 09:28:08 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Neal Gompa <ngompa13@gmail.com>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v1 00/12] fscrypt: add extent encryption
Message-ID: <20230705162808.GA2003@sol.localdomain>
References: <cover.1687988246.git.sweettea-kernel@dorminy.me>
 <20230703045417.GA3057@sol.localdomain>
 <712d5490-8f36-f41d-4488-91e86e694cad@dorminy.me>
 <20230703181745.GA1194@sol.localdomain>
 <6a7d0d4a-9c79-e47d-7968-e508c266407d@dorminy.me>
 <20230704002854.GA860@sol.localdomain>
 <9c589884-d033-f277-58bf-735ba9120f14@dorminy.me>
 <CAEg-Je_zGBAgPLgpnjWbRwGLXNSpmor-mokZyMT6iSfF2121QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEg-Je_zGBAgPLgpnjWbRwGLXNSpmor-mokZyMT6iSfF2121QQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jul 05, 2023 at 08:13:34AM -0400, Neal Gompa wrote:
> On Mon, Jul 3, 2023 at 10:03 PM Sweet Tea Dorminy
> <sweettea-kernel@dorminy.me> wrote:
> >
> >
> > >>> I do recall some discussion of making it possible to set an encryption policy on
> > >>> an *unencrypted* directory, causing new files in that directory to be encrypted.
> > >>> However, I don't recall any discussion of making it possible to add another
> > >>> encryption policy to an *already-encrypted* directory.  I think this is the
> > >>> first time this has been brought up.
> > >>
> > >> I think I referenced it in the updated design (fifth paragraph of "Extent
> > >> encryption" https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7iDaCDQQNZA/edit?usp=sharing)
> > >> but I didn't talk about it enough -- 'rekeying' is a substitute for adding a
> > >> policy to a directory full of unencrypted data. Ya'll's points about the
> > >> badness of having mixed unencrypted and encrypted data in a single dir were
> > >> compelling. (As I recall it, the issue with having mixed enc/unenc data is
> > >> that a bug or attacker could point an encrypted file autostarted in a
> > >> container, say /container/my-service, at a unencrypted extent under their
> > >> control, say /bin/bash, and thereby acquire a backdoor.)
> > >>>
> > >>> I think that allowing directories to have multiple encryption policies would
> > >>> bring in a lot of complexity.  How would it be configured, and what would the
> > >>> semantics for accessing it be?  Where would the encryption policies be stored?
> > >>> What if you have added some of the keys but not all of them?  What if some of
> > >>> the keys get removed but not all of them?
> > >> I'd planned to use add_enckey to add all the necessary keys, set_encpolicy
> > >> on an encrypted directory under the proper conditions (flags interpreted by
> > >> ioctl? check if filesystem has hook?) recursively calls a
> > >> filesystem-provided hook on each inode within to change the fscrypt_context.
> > >
> > > That sounds quite complex.  Recursive directory operations aren't really
> > > something the kernel does.  It would also require updating every inode, causing
> > > COW of every inode.  Isn't that something you'd really like to avoid, to make
> > > starting a new container as fast and lightweight as possible?
> >
> > A fair point. Can move the penalty to open or write time instead though:
> > btrfs could store a generation number with the new context on only the
> > directory changed, then leaf inodes or new extent can traverse up the
> > directory tree and grab context from the highest-generation-number
> > directory in its path to inherit from. Or btrfs could disallow changing
> > except on the base of a subvolume, and just go directly to the top of
> > the subvolume to grab the appropriate context. Neither of those require
> > recursion outside btrfs.
> >
> > >> On various machines, we currently have a btrfs filesystem containing various
> > >> volumes/snapshots containing starting states for containers. The snapshots
> > >> are generated by common snapshot images built centrally. The machines, as
> > >> the scheduler requests, start and stop containers on those volumes.
> > >>
> > >> We want to be able to start a container on a snapshot/volume such that every
> > >> write to the relevant snapshot/volume is using a per-container key, but we
> > >> don't care about reads of the starting snapshot image being encrypted since
> > >> the starting snapshot image is widely shared. When the container is stopped,
> > >> no future different container (or human or host program) knows its key. This
> > >> limits the data which could be lost to a malicious service/human on the host
> > >> to only the volumes containing currently running containers.
> > >>
> > >> Some other folks envision having a base image encrypted with some per-vendor
> > >> key. Then the machine is rekeyed with a per-machine key in perhaps the TPM
> > >> to use for updates and logfiles. When a user is created, a snapshot of a
> > >> base homedir forms the base of their user subvolume/directory, which is then
> > >> rekeyed with a per-user key. When the user logs in, systemd-homedir or the
> > >> like could load their per-user key for their user subvolume/directory.
> > >>
> > >> Since we don't care about encrypting the common image, we initially
> > >> envisioned unencrypted snapshot images where we then turn on encryption and
> > >> have mixed unenc/enc data. The other usecase, though, really needs key
> > >> change so that everything's encrypted. And the argument that mixed unenc/enc
> > >> data is not safe was compelling.
> > >>
> > >> Hope that helps?
> > >
> > > Maybe a dumb question: why aren't you just using overlayfs?  It's already
> > > possible to use overlayfs with an fscrypt-encrypted upperdir and workdir.  When
> > > creating a new container you can create a new directory and assign it an fscrypt
> > > policy (with a per-container or per-user key or whatever that container wants),
> > > and create two subdirectories 'upperdir' and 'workdir' in it.  Then just mount
> > > an overlayfs with that upperdir and workdir, and lowerdir referring to the
> > > starting rootfs.  Then use that overlayfs as the rootfs as the container.
> > >
> > > Wouldn't that solve your use case exactly?  Is there a reason you really want to
> > > create the container directly from a btrfs snapshot instead?
> >
> > Hardly; a quite intriguing idea. Let me think about this with folks when
> > we get back to work on Wednesday. Not sure how it goes with the other
> > usecase, the base image/per-machine/per-user combo, but will think about it.
> 
> I like creating containers directly based on my host system for
> development and destructive purposes. It saves space and is incredibly
> useful.

A solution for that already exists.  It's called btrfs snapshots.  Which you
probably already know, since it's probably what you're using :-)

Using overlayfs would simply mean that each container consists of an upper and
lower directory instead of a single directory.  Either or both could still be
btrfs subvolumes.  They could even be on the same subvolume.

> 
> But the layered key encryption thing is also core to the encryption
> strategy we want to take in Fedora, so I would really like to see this
> be possible with Btrfs encryption.
> 
> Critically, it means that unlocking a user subvolume will always be
> multi-factor: something you have (machine key) and something you know
> (user credentials).

That's possible with the existing fscrypt semantics.  Just use a unique master
key for each container, and protect it with a key derived from both the machine
key *and* the user credential.  Protecting the fscrypt master key(s) is a
userspace problem, not a kernel one.  The kernel just receives the raw key.

- Eric
