Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6B9746694
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Jul 2023 02:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjGDA3A (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 3 Jul 2023 20:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjGDA27 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 3 Jul 2023 20:28:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A704E6;
        Mon,  3 Jul 2023 17:28:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A654F61088;
        Tue,  4 Jul 2023 00:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C5FC433C8;
        Tue,  4 Jul 2023 00:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688430536;
        bh=CYGZGzws5TogEc4lKXTUS8J8/WZ/a3IdNwmdiNeGxwQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZObuT7j9dl5yQyF7J1OIWHvrJOhabqOWolWurWasEW3DYanf8UobqrAWC4z78AZk/
         JkaE79UiineEO5vjGpIgiQdo3Wfwnox7qliesHUlNAgaA6D4SgRrl4SktdVRgcXcEi
         0JEh/086OpBs27SOXNgLXR5OSgVhwWE0REVITS9QDmP/tHDUCwI7IOSr5CSVClcLhE
         MC1qIFUPlfrT38zbOrBmP2Ns+PrmBwJxguLTKU+y7O37fOflgaeZ6y7E3pnT087PcN
         6hziOpT64NUUMVBwqPWRtKv31RwGQM34z1Y8dhBmaZAynaeSjdznGKAZiI/SEOnmWM
         GF6skMlimgsrg==
Date:   Mon, 3 Jul 2023 17:28:54 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v1 00/12] fscrypt: add extent encryption
Message-ID: <20230704002854.GA860@sol.localdomain>
References: <cover.1687988246.git.sweettea-kernel@dorminy.me>
 <20230703045417.GA3057@sol.localdomain>
 <712d5490-8f36-f41d-4488-91e86e694cad@dorminy.me>
 <20230703181745.GA1194@sol.localdomain>
 <6a7d0d4a-9c79-e47d-7968-e508c266407d@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a7d0d4a-9c79-e47d-7968-e508c266407d@dorminy.me>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jul 03, 2023 at 04:37:52PM -0400, Sweet Tea Dorminy wrote:
> 
> On 7/3/23 14:17, Eric Riggers wrote:
> > On Mon, Jul 03, 2023 at 01:06:17PM -0400, Sweet Tea Dorminy wrote:
> > > > 
> > > > I think that would avoid many of the problems that it seems you've had to work
> > > > around or have had to change user-visible semantics for.  For example the
> > > > problems involving master keys being added and removed.  It would also avoid
> > > > having to overload 'fscrypt_info' to be either a per-inode or a per-extent key.
> > > > And it would save space on disk and in memory.
> > > 
> > > I might be misunderstanding what you're referencing, but I think you're
> > > talking about the change where with extent fscrypt, IO has to be forced down
> > > before removing a key, otherwise it is lost. I think that's a fundamental
> > > problem given the filesystem has no way to know that there are new, dirty
> > > pages in the pagecache until those pages are issued for write, so it can't
> > > create a new extent or few until that point, potentially after the relevant
> > > key has been evicted. But maybe I'm missing a hook that would let us make
> > > extents earlier.
> > > 
> > > I suppose we could give each leaf inode a proper nonce/prepared key instead
> > > of borrowing its parent dir's: if a write came in after the key was removed
> > > but the inode is still open, the new extent(s) could grab the key material
> > > out of the inode's info. I don't like this very much since it could result
> > > in multiple extents grabbing the same key material, but I suppose it could
> > > work if it's important to maintain that behavior.
> > 
> > Right, if extent keys are derived directly from the master key, and
> > FS_IOC_REMOVE_ENCRYPTION_KEY is executed which causes the master key secret to
> > be wiped, then no more extent keys can be derived.
> > 
> > So I see why you implemented the behavior you did.  It does seem a bit
> > dangerous, though.  If I understand correctly, under your proposal, if
> > FS_IOC_REMOVE_ENCRYPTION_KEY is executed while a process is doing buffered
> > writes to an encrypted file protected by that key, then past writes will get
> > synced out just before the key removal, but future writes will just be silently
> > thrown away.  (Remember, writes in Linux are asynchronous; processes don't get
> > informed of write errors unless they call fsync() or are doing direct I/O.)
> > I wonder if we should just keep the master key around, for per-extent key
> > derivation only, until all files using that master key have been closed.  That
> > would minimize the changes from the current fscrypt semantics.
> 
> That would work, if you're good with that. It felt like a larger deviation,
> with the possibility of unbounded continued use of a soft-removed master
> key;

Yes, it's not ideal, but essentially that same behavior already exists for the
encryption settings that don't use per-file keys.

The fact is that key removal with in-use files is always going to be
"incomplete".  People who really need the key removal to work properly need to
ensure that all files are closed first, or at least ensure that they're closed
eventually and keep retrying the key removal until then...

> should fscrypt restrict use of the master key only to extents that are
> part of inodes that are already open?

Yes, I think so.  That way the user-visible semantics would stay the same as is
currently the case for fscrypt.

> > > > Can you elaborate on why you went with a more "heavyweight" extents design?
> > > Being able to rekey a directory is the reason for having full contexts:
> > > suppose I take a snapshot of an encrypted dir and want to change the key for
> > > new data going forward, to avoid using a single key on too much data. It's
> > > too expensive to reencrypt every extent with the new key, since the whole
> > > point of a snapshot is to make a lightweight copy that gets COWed on write.
> > > Then each extent needs to know what its own master key
> > > identifier/policy/flags are, since different extents in the same file could
> > > have different master keys. We could say the mode and flags have to match,
> > > but it doesn't seem to me worth saving seven bytes to add a new structure to
> > > just store the master key identifier and nonce.
> > > 
> > > For a non-Meta usecase, from what I've heard from Fedora-land, it's possibly
> > > interesting to them to be able to ship an encrypted image, and then be able
> > > to change the key after encrypted install to something user-controlled.
> > > 
> > > Without rekeying, my understanding is that we may write too much data with
> > > one key for safety; notes in the updated design doc https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7iDaCDQQNZA/edit?usp=sharing
> > > are that writing more than 1P per key raises cryptographic concerns, and
> > > since btrfs is COW and could have volumes up to the full 16E size that btrfs
> > > supports, we don't want to have just one immutable key per subvol.
> > > 
> > > To me the lightweight-on-disk vision sounds a lot like the original design:
> > > https://lore.kernel.org/linux-btrfs/YXGyq+buM79A1S0L@relinquished.localdomain
> > > and the Nov '22 version of the patchset: https://lore.kernel.org/linux-btrfs/cover.1667389115.git.sweettea-kernel@dorminy.me/
> > > (which didn't have rekeying). I think rekeying is worth the higher disk
> > > usage; but I'm probably missing something about how your vision differs from
> > > the original. Could you please take a look at it again?
> > 
> > Your original design didn't use per-extent keys, but rather had a single
> > contents encryption key per master key.  We had discussed that that approach had
> > multiple disadvantages, one of which is that on btrfs it can run uncomfortably
> > close to the cryptographic limits for the contents encryption modes such as
> > AES-XTS.  So we decided to go with per-extent keys instead.
> 
> > I don't think we discussed cryptographic limits on the master key itself.  That
> > is actually much less of a concern, as the master key is just used for
> > HKDF-SHA512.  I don't think there is any real need to ever change the master
> > key.  (Well, if it is compromised, it could be needed, but that's not really
> > relevant here.  If that happens you'd need to re-encrypt everything anyway.)
> So you're proposing just storing a nonce per extent, then setting up a
> prepared key only, taking the inode's master key and doing the hkdf expand
> with the nonce into the prepared key? A terse approach, a lot closer to the
> original design than I thought.

Yes.

> > I do recall some discussion of making it possible to set an encryption policy on
> > an *unencrypted* directory, causing new files in that directory to be encrypted.
> > However, I don't recall any discussion of making it possible to add another
> > encryption policy to an *already-encrypted* directory.  I think this is the
> > first time this has been brought up.
> 
> I think I referenced it in the updated design (fifth paragraph of "Extent
> encryption" https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7iDaCDQQNZA/edit?usp=sharing)
> but I didn't talk about it enough -- 'rekeying' is a substitute for adding a
> policy to a directory full of unencrypted data. Ya'll's points about the
> badness of having mixed unencrypted and encrypted data in a single dir were
> compelling. (As I recall it, the issue with having mixed enc/unenc data is
> that a bug or attacker could point an encrypted file autostarted in a
> container, say /container/my-service, at a unencrypted extent under their
> control, say /bin/bash, and thereby acquire a backdoor.)
> > 
> > I think that allowing directories to have multiple encryption policies would
> > bring in a lot of complexity.  How would it be configured, and what would the
> > semantics for accessing it be?  Where would the encryption policies be stored?
> > What if you have added some of the keys but not all of them?  What if some of
> > the keys get removed but not all of them?
> I'd planned to use add_enckey to add all the necessary keys, set_encpolicy
> on an encrypted directory under the proper conditions (flags interpreted by
> ioctl? check if filesystem has hook?) recursively calls a
> filesystem-provided hook on each inode within to change the fscrypt_context.

That sounds quite complex.  Recursive directory operations aren't really
something the kernel does.  It would also require updating every inode, causing
COW of every inode.  Isn't that something you'd really like to avoid, to make
starting a new container as fast and lightweight as possible?

> Either dir items could be reencrypted with the new key or dirs could keep
> around the oldest key for encryption and the newest key for new leaf inodes
> to inherit.
> 
> For leaf inodes, 2 options for the remaining questions:
> 
> 1) leaf inodes just stores the policy to be used for writing new data or
> inherits it from a parent directory. If you're reading and you hit an extent
> whose key isn't loaded, you get an IO error. If you're writing and you try
> to write to an inode who needs a key that isn't loaded, you get an IO error
> eventually.
> 
> This is what I'd prefer: Josef and Chris and I discussed this a while back
> and thought this was acceptable semantics for our uses, I think, and it's
> simple; you can already get an IO error if you're reading a file and
> suddenly hit an invalid extent, or if you are writing a file and run out of
> space.
> 
> 2) all inodes store a fscrypt_context for all policies configured for the
> inode. ->get_context() gets a index parameter to get the index'th context.
> directory inodes' info is loaded off the one needed for dir entry
> encryption, leaf inodes' off the newest context. When any inode is opened,
> all the contexts are read and checked that their key is loaded, and then
> discarded, except the one in use for writes to that inode.
> 
> If a key is removed, you get an IO error when you do IO that needs that key,
> with the usual async conditions. Or, some lightweight structure is added to
> each master key's open inode list to point at the inode using it, and the
> inode keeps the master key around while it's open, thereby preventing IO
> errors after open.
> > 
> > Can you elaborate more on why you want this?  I was already a bit concerned
> > about the plan for making it possible to set an encryption policy on an
> > unencrypted directory, as that already diverges from the existing fscrypt
> > semantics.  But now it sounds like the scope has grown even more.
> > 
> > Keep in mind that in general, the closer we are able to stick to the existing
> > fscrypt semantics and design, the easier it is going to be to get the initial
> > btrfs fscrypt support merged.  Planning ahead for new features is good, but we
> > should also be careful not to overdesign.
> 
> Here's a shot at elaboration of usecase more:
> 
> On various machines, we currently have a btrfs filesystem containing various
> volumes/snapshots containing starting states for containers. The snapshots
> are generated by common snapshot images built centrally. The machines, as
> the scheduler requests, start and stop containers on those volumes.
> 
> We want to be able to start a container on a snapshot/volume such that every
> write to the relevant snapshot/volume is using a per-container key, but we
> don't care about reads of the starting snapshot image being encrypted since
> the starting snapshot image is widely shared. When the container is stopped,
> no future different container (or human or host program) knows its key. This
> limits the data which could be lost to a malicious service/human on the host
> to only the volumes containing currently running containers.
> 
> Some other folks envision having a base image encrypted with some per-vendor
> key. Then the machine is rekeyed with a per-machine key in perhaps the TPM
> to use for updates and logfiles. When a user is created, a snapshot of a
> base homedir forms the base of their user subvolume/directory, which is then
> rekeyed with a per-user key. When the user logs in, systemd-homedir or the
> like could load their per-user key for their user subvolume/directory.
> 
> Since we don't care about encrypting the common image, we initially
> envisioned unencrypted snapshot images where we then turn on encryption and
> have mixed unenc/enc data. The other usecase, though, really needs key
> change so that everything's encrypted. And the argument that mixed unenc/enc
> data is not safe was compelling.
> 
> Hope that helps?

Maybe a dumb question: why aren't you just using overlayfs?  It's already
possible to use overlayfs with an fscrypt-encrypted upperdir and workdir.  When
creating a new container you can create a new directory and assign it an fscrypt
policy (with a per-container or per-user key or whatever that container wants),
and create two subdirectories 'upperdir' and 'workdir' in it.  Then just mount
an overlayfs with that upperdir and workdir, and lowerdir referring to the
starting rootfs.  Then use that overlayfs as the rootfs as the container.

Wouldn't that solve your use case exactly?  Is there a reason you really want to
create the container directly from a btrfs snapshot instead?

- Eric
