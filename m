Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC897483F7
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 Jul 2023 14:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjGEMO0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 5 Jul 2023 08:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbjGEMOY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 5 Jul 2023 08:14:24 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D6F19BD;
        Wed,  5 Jul 2023 05:14:12 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2b6fbf0c0e2so18750371fa.2;
        Wed, 05 Jul 2023 05:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688559251; x=1691151251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LNX/hxphEoNKkDUNMJjClNtkg2gxjlckT18aiJyhqS0=;
        b=VbBDjkac5WmibS+sDdpBdb07oLoQnHHPrX06vXhNNPhEmzpLDvH6Djz9vXzJUl7Zi6
         3kwi2N7eZbExpcIJqg+PA0HWKo0wRGl+P3ekKudPhatNdyUU6YTWAkk6vPFtR5fANcj8
         fQZEnG7dHb4P3KvBzVIBe254pO7U/x11BjhCLqNwbAfIpdIxTves4l2ZDD8951FQhKwy
         gpM8/loxjVgspG/KU92pDB4sij2wBaAmlVh+zYTtEoVz8gTg8NEpQIfnE2cvSR6lcIXz
         jqENQ5HFFgH2MTDeIHbQqtm7HfyImGv8vgOxquHOIBSUuUPnvCMw3wZKLnGZ7uEWw9Zb
         fHCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688559251; x=1691151251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LNX/hxphEoNKkDUNMJjClNtkg2gxjlckT18aiJyhqS0=;
        b=KU5BpLtTgDPlVxPa9YLipqvPeA7s6nkbiswEt3snGwYnQJryh7lGM7eU6WEg0GClIy
         njbwo2QOwyiTVSjyyB/X6qvWQQXjwlxGgAIZYVWu5zRlKP5yF1LPDiOxLDiODTHwleNr
         H3fWxVB1B9zNdg11q/usk4ztNMm05a8eembAdNTamN5DnbF6xXfLk9gMrVHOS0vhWNOo
         zHVvyVRHdxoRYr8zsJKy1WmqSns20GiDjNTFw/MhBirqcVBqlYd96XO1HDxjaP1vfPcp
         y1Un8vNZ0i0LHFVC1gDt61pyzQi7YGA7S498p8jbxytyknzwr8lIONdDGM4wg2CW4vRQ
         FTyw==
X-Gm-Message-State: ABy/qLaHX4FoChgiCm9vpa9Wa2OBiTwMowAGTlNWHwpiQlfs5dHMy6YX
        K16SzXj8sSiCAgbQSs8tBdrzQknOSjMqPYP+x1s=
X-Google-Smtp-Source: APBJJlF/6zAGJCf+pDUo4POjUlu9H22ehiXyUtA4SONeYkIPXlm8Nn6iSCDMjFPtob9bj6jGt+hgWoxO2hrlOuu4PpU=
X-Received: by 2002:a2e:8188:0:b0:2b6:cca1:975f with SMTP id
 e8-20020a2e8188000000b002b6cca1975fmr10672603ljg.13.1688559250488; Wed, 05
 Jul 2023 05:14:10 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1687988246.git.sweettea-kernel@dorminy.me>
 <20230703045417.GA3057@sol.localdomain> <712d5490-8f36-f41d-4488-91e86e694cad@dorminy.me>
 <20230703181745.GA1194@sol.localdomain> <6a7d0d4a-9c79-e47d-7968-e508c266407d@dorminy.me>
 <20230704002854.GA860@sol.localdomain> <9c589884-d033-f277-58bf-735ba9120f14@dorminy.me>
In-Reply-To: <9c589884-d033-f277-58bf-735ba9120f14@dorminy.me>
From:   Neal Gompa <ngompa13@gmail.com>
Date:   Wed, 5 Jul 2023 08:13:34 -0400
Message-ID: <CAEg-Je_zGBAgPLgpnjWbRwGLXNSpmor-mokZyMT6iSfF2121QQ@mail.gmail.com>
Subject: Re: [PATCH v1 00/12] fscrypt: add extent encryption
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jul 3, 2023 at 10:03=E2=80=AFPM Sweet Tea Dorminy
<sweettea-kernel@dorminy.me> wrote:
>
>
> >>> I do recall some discussion of making it possible to set an encryptio=
n policy on
> >>> an *unencrypted* directory, causing new files in that directory to be=
 encrypted.
> >>> However, I don't recall any discussion of making it possible to add a=
nother
> >>> encryption policy to an *already-encrypted* directory.  I think this =
is the
> >>> first time this has been brought up.
> >>
> >> I think I referenced it in the updated design (fifth paragraph of "Ext=
ent
> >> encryption" https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa=
7OhCgB8Gdx7iDaCDQQNZA/edit?usp=3Dsharing)
> >> but I didn't talk about it enough -- 'rekeying' is a substitute for ad=
ding a
> >> policy to a directory full of unencrypted data. Ya'll's points about t=
he
> >> badness of having mixed unencrypted and encrypted data in a single dir=
 were
> >> compelling. (As I recall it, the issue with having mixed enc/unenc dat=
a is
> >> that a bug or attacker could point an encrypted file autostarted in a
> >> container, say /container/my-service, at a unencrypted extent under th=
eir
> >> control, say /bin/bash, and thereby acquire a backdoor.)
> >>>
> >>> I think that allowing directories to have multiple encryption policie=
s would
> >>> bring in a lot of complexity.  How would it be configured, and what w=
ould the
> >>> semantics for accessing it be?  Where would the encryption policies b=
e stored?
> >>> What if you have added some of the keys but not all of them?  What if=
 some of
> >>> the keys get removed but not all of them?
> >> I'd planned to use add_enckey to add all the necessary keys, set_encpo=
licy
> >> on an encrypted directory under the proper conditions (flags interpret=
ed by
> >> ioctl? check if filesystem has hook?) recursively calls a
> >> filesystem-provided hook on each inode within to change the fscrypt_co=
ntext.
> >
> > That sounds quite complex.  Recursive directory operations aren't reall=
y
> > something the kernel does.  It would also require updating every inode,=
 causing
> > COW of every inode.  Isn't that something you'd really like to avoid, t=
o make
> > starting a new container as fast and lightweight as possible?
>
> A fair point. Can move the penalty to open or write time instead though:
> btrfs could store a generation number with the new context on only the
> directory changed, then leaf inodes or new extent can traverse up the
> directory tree and grab context from the highest-generation-number
> directory in its path to inherit from. Or btrfs could disallow changing
> except on the base of a subvolume, and just go directly to the top of
> the subvolume to grab the appropriate context. Neither of those require
> recursion outside btrfs.
>
> >> On various machines, we currently have a btrfs filesystem containing v=
arious
> >> volumes/snapshots containing starting states for containers. The snaps=
hots
> >> are generated by common snapshot images built centrally. The machines,=
 as
> >> the scheduler requests, start and stop containers on those volumes.
> >>
> >> We want to be able to start a container on a snapshot/volume such that=
 every
> >> write to the relevant snapshot/volume is using a per-container key, bu=
t we
> >> don't care about reads of the starting snapshot image being encrypted =
since
> >> the starting snapshot image is widely shared. When the container is st=
opped,
> >> no future different container (or human or host program) knows its key=
. This
> >> limits the data which could be lost to a malicious service/human on th=
e host
> >> to only the volumes containing currently running containers.
> >>
> >> Some other folks envision having a base image encrypted with some per-=
vendor
> >> key. Then the machine is rekeyed with a per-machine key in perhaps the=
 TPM
> >> to use for updates and logfiles. When a user is created, a snapshot of=
 a
> >> base homedir forms the base of their user subvolume/directory, which i=
s then
> >> rekeyed with a per-user key. When the user logs in, systemd-homedir or=
 the
> >> like could load their per-user key for their user subvolume/directory.
> >>
> >> Since we don't care about encrypting the common image, we initially
> >> envisioned unencrypted snapshot images where we then turn on encryptio=
n and
> >> have mixed unenc/enc data. The other usecase, though, really needs key
> >> change so that everything's encrypted. And the argument that mixed une=
nc/enc
> >> data is not safe was compelling.
> >>
> >> Hope that helps?
> >
> > Maybe a dumb question: why aren't you just using overlayfs?  It's alrea=
dy
> > possible to use overlayfs with an fscrypt-encrypted upperdir and workdi=
r.  When
> > creating a new container you can create a new directory and assign it a=
n fscrypt
> > policy (with a per-container or per-user key or whatever that container=
 wants),
> > and create two subdirectories 'upperdir' and 'workdir' in it.  Then jus=
t mount
> > an overlayfs with that upperdir and workdir, and lowerdir referring to =
the
> > starting rootfs.  Then use that overlayfs as the rootfs as the containe=
r.
> >
> > Wouldn't that solve your use case exactly?  Is there a reason you reall=
y want to
> > create the container directly from a btrfs snapshot instead?
>
> Hardly; a quite intriguing idea. Let me think about this with folks when
> we get back to work on Wednesday. Not sure how it goes with the other
> usecase, the base image/per-machine/per-user combo, but will think about =
it.

I like creating containers directly based on my host system for
development and destructive purposes. It saves space and is incredibly
useful.

But the layered key encryption thing is also core to the encryption
strategy we want to take in Fedora, so I would really like to see this
be possible with Btrfs encryption.

Critically, it means that unlocking a user subvolume will always be
multi-factor: something you have (machine key) and something you know
(user credentials).


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
