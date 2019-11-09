Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4738AF60DD
	for <lists+linux-fscrypt@lfdr.de>; Sat,  9 Nov 2019 19:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfKISqa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 9 Nov 2019 13:46:30 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:43847 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726496AbfKISq3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 9 Nov 2019 13:46:29 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id D5A034E4;
        Sat,  9 Nov 2019 13:46:28 -0500 (EST)
Received: from imap37 ([10.202.2.87])
  by compute3.internal (MEProxy); Sat, 09 Nov 2019 13:46:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=q37XMx
        9ux+luvxnTDE6lP8jnm5E4HF6jIgiGP4uH2Rg=; b=depwu0YHC5AFur6n2jSeLG
        wcYWoci2BAa0CQLs8xOA0nSfT1ywQKouEIoYWmCPcot+DArOFPx7h7XsSf/lZkl9
        eQbZi59OqnWwYKfDRkOJlQPRc7xqPs+sSaPhqF4UyNnJ0+73ZFpcHFc5vLydH0uS
        8OTRZ+gPzIKuC3vLgrnC1xG2SG0JkykCXoNINsbPdo256TJKBYJVoGnm8ntJg/Rq
        u9xBPWN1JIr5sGSZxjVo/Mehi13IqMEo9S0QfgqZ8vS0ElPlENMnqPkpyC0K4xpK
        NJWINFo6idbIOvGqadfZatYqQb39qWl32Jo3abA0/CdVv8WF95nc7f/ekZnTDJEQ
        ==
X-ME-Sender: <xms:hAnHXfEnZoiB-TiDeWxrasIH90Tj_6mAvhbonHFpFyc342GSluI-3g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvfedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfveho
    lhhinhcuhggrlhhtvghrshdfuceofigrlhhtvghrshesvhgvrhgsuhhmrdhorhhgqeenuc
    ffohhmrghinheprghnughrohhiugdrtghomhdpvgiffidrrghspdhgihhthhhusgdrtgho
    mhdpvhgvrhgsuhhmrdhorhhgnecurfgrrhgrmhepmhgrihhlfhhrohhmpeifrghlthgvrh
    hssehvvghrsghumhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:hAnHXVEf7y6kWNQYXt5Fz_F2HH7kCzpj04iGQ974OrXTYYLuJakhUA>
    <xmx:hAnHXTVRFOA4Q90YHbzbKKvJATOx5ztMepYv3-vj18AXqyId8Gtq8Q>
    <xmx:hAnHXT7oOjyXuIcLZFWssPpqFCUqx4fyP_jgFtUGWG5iiwy7W-6zYQ>
    <xmx:hAnHXTVcRmh93X0--Mkskc-9qi5slR8iYgTxvdNjTaQXY1LkSZxDqg>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 1CAFC684005F; Sat,  9 Nov 2019 13:46:28 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.7-509-ge3ec61c-fmstable-20191030v1
Mime-Version: 1.0
Message-Id: <ec3d8041-e791-4016-943c-f1dade1be5eb@www.fastmail.com>
In-Reply-To: <20191109034150.GC9739@sol.localdomain>
References: <696354c2-5d7a-4f37-93d2-9a58845ad22d@www.fastmail.com>
 <20191109034150.GC9739@sol.localdomain>
Date:   Sat, 09 Nov 2019 13:46:06 -0500
From:   "Colin Walters" <walters@verbum.org>
To:     "Eric Biggers" <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: Some questions/thoughts on fs-verity
Content-Type: text/plain
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Nov 8, 2019, at 10:41 PM, Eric Biggers wrote:

> Can you take a step back and consider what security properties you're actually
> trying to achieve? 

I'd like similar security properties to a full dm-verity bootable OS image - if someone gains CAP_SYS_ADMIN and the ability to subvert LSMs etc. and write arbitrary files (and most ideally protection against writes to underlying raw block devices), there should not be a "persistence vector" that allows them to regain CAP_SYS_ADMIN after a reboot (automatically, without re-doing an exploit).

This assumes that the userspace won't go off and execute unverified code from outside the root; see also
https://blog.verbum.org/2017/06/12/on-dm-verity-and-operating-systems/

> In particular, be aware that if you just enable fs-verity on
> a file but never actually compare the hash to anything, it provides integrity
> only (detection of accidental corruption), not any authenticity protection.

Right; as I note in the PR just to start
" Among other things, it does finally add an API that makes files immutable, which will help against some accidental damage."

Content immutable but still unlink() and link()-able being key here.

> In your pull request to OSTree (https://github.com/ostreedev/ostree/pull/1959),
> I see a call to FS_IOC_ENABLE_VERITY.  But there's no corresponding call to
> FS_IOC_MEASURE_VERITY to actually authenticate the file(s), nor is fs-verity's
> built-in signature verification feature being used.  So this is integrity-only;
> there's no protection against malicious modifications to the data on-disk.

Yes, I understand that, but I didn't investigate that too much exactly because of the issues I noted in my original mail; it doesn't help my use case much to measure files if e.g. one can gain code execution by other means.
 
> I.e., fs-verity is really meant to be used as part of a userspace-driven
> authentication policy.  It's not something that magically increases security by
> itself.  That's partly why the scope of fs-verity is limited to file contents:
> userspace can still authenticate other metadata if needed.

If I understand correctly, for the Android/ChromeOS use case, fs-verity will be applied to application ZIP files, and the base OS userspace will verify their signatures before launching.  That seems straightforward.  But that approach effectively requires abandoning a model of writing files directly to the filesystem and instead serializing to a tarball/zipfile.  Being able to support e.g. traditional OCI/Docker-style container images (where all of userspace expects to use the open() syscall rather than e.g. a special resource API[1]) on such a system would require something like a FUSE mount of a fs-verity tarball/zipfile (right?). It's *possible* but FUSE has all sorts of downsides.

It also means (if implemented naively at least) you have similar "write amplification" issues - if just a few files change in an app, you end up having to re-write a full zip/tarball.

Further, for the actual base OS case...hmm, I guess we could run a FUSE mount in the initramfs or so, but...eww.

> As for an attacker exploiting a filesystem bug, yes that is a big problem
> currently in Linux.  However, gaining code execution via such a bug is a *bug*
> and is patchable and mitigable, whereas gaining code execution by modifying
> unauthenticated code stored on-disk is simply working as intended.

Often when I use the term "secure" I mean "As a software vendor, we believe we can fix security issues with this over time, and there won't be too many to be embarrassing".   Canonical examples here being virtualization and container systems like Docker/podman/etc.

It sounds like you're saying you believe that (at least ext4?) could be secure in this sense - it's not clear to me (from previous discussions) that other filesystem developers agree (at least for their filesystems).

Anyways, to restate the goal - having the security properties of a dm-verity base OS, but with a lot more flexiblity (no fixed partition size, can easily have 3 or more images, etc.).

For example, I could imagine some API that allows userspace to also "seal" a directory and symlinks (inside the filesystem, this could end up stored similarly to a fs-verity file).  That'd be a powerful primitive, because one wouldn't need to store everything inside zip files, and it'd be much easier to e.g. have userspace verify the root hash of a sealed directory and have everything else trusted from that.  For example, without having to patch systemd to learn how to measure unit files.

Or really a bottom line here is - I could imagine reworking our userspace to do this FUSE mount of fs-verity tarball model, but if e.g. the kernel filesystems aren't really feasably made safe against malicious code, then...it may not be worth doing.

[1] https://developer.android.com/guide/topics/resources/providing-resources
