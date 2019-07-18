Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 049E66C4E1
	for <lists+linux-fscrypt@lfdr.de>; Thu, 18 Jul 2019 04:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbfGRCMa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 17 Jul 2019 22:12:30 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:40331 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbfGRCM3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 17 Jul 2019 22:12:29 -0400
Received: by mail-pl1-f178.google.com with SMTP id a93so12977316pla.7
        for <linux-fscrypt@vger.kernel.org>; Wed, 17 Jul 2019 19:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=9UhAcKbX9OyfTUm3M7LUM/06UzzrER4TCmWzAqMqyyY=;
        b=N/cG2rO8OJyi+JiGwsjaquO6y3RJnAJ4cPMn4jZZdSWRqe5NxU2Xav/2y6zgf/0jvZ
         jjO1UkZgwpru7YuGF/NdCI1MGtaNxrd7b1vEb9//Vw+3opu1MddlIw51s9P3wrfbPVE8
         7TieU8Gdy4V5rBN+k2UJF6HTR/Q4k0fAJMnWwP0jXCFH4EZrjNXkaanTS4faaV70cI78
         R0tkyx1C/6dRlJbZVJk3qaC49CoNGSmMWDYwu9+Xvm1S6O5UZ9PtvysO24pMEcLf4hyj
         7RYpWxDbqF3WviiwcWLufzayQ4L2ai7d150P3+Jc0EE0nkoHvXBVxbkNEfuJeTKL3+k2
         1pTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=9UhAcKbX9OyfTUm3M7LUM/06UzzrER4TCmWzAqMqyyY=;
        b=HxjZpX0TFfqIW9j4wD6yd1YzG2+IbApMuqiujzV9HbvmHhW6Ty4g7f19p5cwjjoQBB
         g1W7ckgbIyxmfo/1NGzgTmYz7WOXK0oc7kuuLK0RjeSsiqow5P7EnY2TaJ4M3CM7nX5u
         0BUmbXM76ks683iweR0Ob4NZx/3t3O0IXsn8yqoJscaWeCU1/CMzwV8fEeoE9bis2uyR
         0WCQM6ZgOVXpgHtD8E2+Ir0V2GrY9KSTVgcU0FxtsMpARyNMlx7NwcsTdSK5LJBFyd2B
         0zDBf1J1+UiN762wB3VOIbVLxFRfI8TDY34qKRkMKXYaucVRBXncACGi1So8Ma4A/V1G
         4aXA==
X-Gm-Message-State: APjAAAUrvW89N12Sm6CmWy4dxgoClLC7K6IJLkMBayV5WUI5EWfr2FWK
        NtqJWDjkx/KmxcvC6IWB396v7PeXOjs=
X-Google-Smtp-Source: APXvYqwWPqTuO9EWZwrVvQ/XdescvkTGo2bFahuXLREyQvUoz7Q8C99FajAGrvRhsyl+yV7WeftPWA==
X-Received: by 2002:a17:902:9a49:: with SMTP id x9mr47439097plv.282.1563415947500;
        Wed, 17 Jul 2019 19:12:27 -0700 (PDT)
Received: from ?IPv6:2605:8d80:403:498a:d914:60db:93d2:5d51? ([2605:8d80:403:498a:d914:60db:93d2:5d51])
        by smtp.gmail.com with ESMTPSA id j20sm24517098pfr.113.2019.07.17.19.12.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jul 2019 19:12:26 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] e2fsck: check for consistent encryption policies
From:   Andreas Dilger <adilger@dilger.ca>
X-Mailer: iPhone Mail (16F203)
In-Reply-To: <20190718011325.19516-1-ebiggers@kernel.org>
Date:   Wed, 17 Jul 2019 20:12:25 -0600
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <621FA6A1-745D-43BA-A52A-4229902737BF@dilger.ca>
References: <20190718011325.19516-1-ebiggers@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

It would appear from my reading of the patch that every file that is
encrypted will have the xattr saved until pass2? If the filesystem is very
large (eg. billions of files), this will consume a large amount of memory.

Does it make sense to compare compression xattrs during pass1,
and only track the set of different
encryption context/type/master key
sets that exist in the filesystem?  Since these will typically be common
among large numbers of files, the memory will be largely reduced,
maybe one or two ints per inode (either an inode+ID pair for sparse
inodes, or just an ID for dense range of similarly-encrypted inodes with a
start+count for the whole range.=20

Cheers, Andreas

> On Jul 17, 2019, at 19:13, Eric Biggers <ebiggers@kernel.org> wrote:
>=20
> From: Eric Biggers <ebiggers@google.com>
>=20
> By design, the kernel enforces that all files in an encrypted directory
> use the same encryption policy as the directory.  It's not possible to
> violate this constraint using syscalls.  Lookups of files that violate
> this constraint also fail, in case the disk was manipulated.
>=20
> But this constraint can also be violated by accidental filesystem
> corruption.  E.g., a power cut when using ext4 without a journal might
> leave new files without the encryption bit and/or xattr.  Thus, it's
> important that e2fsck correct this condition.
>=20
> Therefore, this patch makes the following changes to e2fsck:
>=20
> - During pass 1 (inode table scan), create a map from inode number to
>  encryption xattr for all encrypted inodes.  If an encrypted inode has
>  a missing or clearly invalid xattr, offer to clear the inode.
>=20
> - During pass 2 (directory structure check), verify that all regular
>  files, directories, and symlinks in encrypted directories use the
>  directory's encryption policy.  Offer to clear any directory entries
>  for which this isn't the case.
>=20
> Add a new test "f_bad_encryption" to test the new behavior.
>=20
> Due to the new checks, it was also necessary to update the existing test
> "f_short_encrypted_dirent" to add an encryption xattr to the test file,
> since it was missing one before, which is now considered invalid.
>=20
> Google-Bug-Id: 135138675
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> e2fsck/Android.bp                       |   1 +
> e2fsck/Makefile.in                      |  17 ++-
> e2fsck/e2fsck.c                         |   5 +-
> e2fsck/e2fsck.h                         |  31 +++-
> e2fsck/encrypted_files.c                | 187 ++++++++++++++++++++++++
> e2fsck/pass1.c                          |  26 +---
> e2fsck/pass2.c                          |  96 ++++++++++--
> e2fsck/problem.c                        |  19 +++
> e2fsck/problem.h                        |  11 ++
> po/POTFILES.in                          |   1 +
> tests/f_bad_encryption/expect.1         | 108 ++++++++++++++
> tests/f_bad_encryption/expect.2         |   7 +
> tests/f_bad_encryption/image.gz         | Bin 0 -> 2009 bytes
> tests/f_bad_encryption/mkimage.sh       | 140 ++++++++++++++++++
> tests/f_bad_encryption/name             |   1 +
> tests/f_short_encrypted_dirent/expect.1 |   2 +-
> tests/f_short_encrypted_dirent/expect.2 |   2 +-
> tests/f_short_encrypted_dirent/image.gz | Bin 925 -> 1008 bytes
> 18 files changed, 608 insertions(+), 46 deletions(-)
> create mode 100644 e2fsck/encrypted_files.c
> create mode 100644 tests/f_bad_encryption/expect.1
> create mode 100644 tests/f_bad_encryption/expect.2
> create mode 100644 tests/f_bad_encryption/image.gz
> create mode 100755 tests/f_bad_encryption/mkimage.sh
> create mode 100644 tests/f_bad_encryption/name
>=20
> diff --git a/e2fsck/Android.bp b/e2fsck/Android.bp
> index f3443127..5c802ac6 100644
> --- a/e2fsck/Android.bp
> +++ b/e2fsck/Android.bp
> @@ -34,6 +34,7 @@ cc_defaults {
>         "sigcatcher.c",
>         "readahead.c",
>         "extents.c",
> +        "encrypted_files.c",
>     ],
>     cflags: [
>         "-Wno-sign-compare",
> diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
> index bc7195f3..f01fae2d 100644
> --- a/e2fsck/Makefile.in
> +++ b/e2fsck/Makefile.in
> @@ -63,7 +63,7 @@ OBJS=3D unix.o e2fsck.o super.o pass1.o pass1b.o pass2.o=
 \
>    dx_dirinfo.o ehandler.o problem.o message.o quota.o recovery.o \
>    region.o revoke.o ea_refcount.o rehash.o \
>    logfile.o sigcatcher.o $(MTRACE_OBJ) readahead.o \
> -    extents.o
> +    extents.o encrypted_files.o
>=20
> PROFILED_OBJS=3D profiled/unix.o profiled/e2fsck.o \
>    profiled/super.o profiled/pass1.o profiled/pass1b.o \
> @@ -74,7 +74,8 @@ PROFILED_OBJS=3D profiled/unix.o profiled/e2fsck.o \
>    profiled/recovery.o profiled/region.o profiled/revoke.o \
>    profiled/ea_refcount.o profiled/rehash.o \
>    profiled/logfile.o profiled/sigcatcher.o \
> -    profiled/readahead.o profiled/extents.o
> +    profiled/readahead.o profiled/extents.o \
> +    profiled/encrypted_files.o
>=20
> SRCS=3D $(srcdir)/e2fsck.c \
>    $(srcdir)/super.c \
> @@ -103,6 +104,7 @@ SRCS=3D $(srcdir)/e2fsck.c \
>    $(srcdir)/logfile.c \
>    $(srcdir)/quota.c \
>    $(srcdir)/extents.c \
> +    $(srcdir)/encrypted_files.c \
>    $(MTRACE_SRC)
>=20
> all:: profiled $(PROGS) e2fsck $(MANPAGES) $(FMANPAGES)
> @@ -572,3 +574,14 @@ extents.o: $(srcdir)/extents.c $(top_builddir)/lib/co=
nfig.h \
>  $(top_builddir)/lib/support/prof_err.h $(top_srcdir)/lib/support/quotaio.=
h \
>  $(top_srcdir)/lib/support/dqblk_v2.h \
>  $(top_srcdir)/lib/support/quotaio_tree.h $(srcdir)/problem.h
> +encrypted_files.o: $(srcdir)/encrypted_files.c $(top_builddir)/lib/config=
.h \
> + $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
> + $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types=
.h \
> + $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.=
h \
> + $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
> + $(top_builddir)/lib/ext2fs/ext2_err.h \
> + $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/hashma=
p.h \
> + $(top_srcdir)/lib/ext2fs/bitops.h $(top_srcdir)/lib/support/profile.h \
> + $(top_builddir)/lib/support/prof_err.h $(top_srcdir)/lib/support/quotaio=
.h \
> + $(top_srcdir)/lib/support/dqblk_v2.h \
> + $(top_srcdir)/lib/support/quotaio_tree.h $(srcdir)/problem.h
> diff --git a/e2fsck/e2fsck.c b/e2fsck/e2fsck.c
> index 3770bfcb..f2a20478 100644
> --- a/e2fsck/e2fsck.c
> +++ b/e2fsck/e2fsck.c
> @@ -138,6 +138,7 @@ errcode_t e2fsck_reset_context(e2fsck_t ctx)
>        ext2fs_u32_list_free(ctx->dirs_to_hash);
>        ctx->dirs_to_hash =3D 0;
>    }
> +    destroy_encrypted_files(ctx);
>=20
>    /*
>     * Clear the array of invalid meta-data flags
> @@ -154,10 +155,6 @@ errcode_t e2fsck_reset_context(e2fsck_t ctx)
>        ext2fs_free_mem(&ctx->invalid_inode_table_flag);
>        ctx->invalid_inode_table_flag =3D 0;
>    }
> -    if (ctx->encrypted_dirs) {
> -        ext2fs_u32_list_free(ctx->encrypted_dirs);
> -        ctx->encrypted_dirs =3D 0;
> -    }
>    if (ctx->inode_count) {
>        ext2fs_free_icount(ctx->inode_count);
>        ctx->inode_count =3D 0;
> diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
> index 2d359b38..10dcb582 100644
> --- a/e2fsck/e2fsck.h
> +++ b/e2fsck/e2fsck.h
> @@ -135,6 +135,22 @@ struct dx_dirblock_info {
> #define DX_FLAG_FIRST        4
> #define DX_FLAG_LAST        8
>=20
> +/*
> + * The encrypted file information structure; stores information for files=
 which
> + * are encrypted.
> + */
> +struct encrypted_file {
> +    ext2_ino_t ino;
> +    void *xattr_value;
> +    size_t xattr_size;
> +};
> +
> +struct encrypted_files {
> +    size_t count;
> +    size_t capacity;
> +    struct encrypted_file *files;
> +};
> +
> #define RESOURCE_TRACK
>=20
> #ifdef RESOURCE_TRACK
> @@ -327,6 +343,11 @@ struct e2fsck_struct {
>     */
>    ext2_u32_list    dirs_to_hash;
>=20
> +    /*
> +     * Encrypted file information
> +     */
> +    struct encrypted_files encrypted_files;
> +
>    /*
>     * Tuning parameters
>     */
> @@ -389,7 +410,6 @@ struct e2fsck_struct {
>    int ext_attr_ver;
>    profile_t    profile;
>    int blocks_per_page;
> -    ext2_u32_list encrypted_dirs;
>=20
>    /* Reserve blocks for root and l+f re-creation */
>    blk64_t root_repair_block, lnf_repair_block;
> @@ -504,8 +524,15 @@ extern ea_key_t ea_refcount_intr_next(ext2_refcount_t=
 refcount,
> extern const char *ehandler_operation(const char *op);
> extern void ehandler_init(io_channel channel);
>=20
> -/* extents.c */
> +/* encrypted_files.c */
> struct problem_context;
> +int add_encrypted_file(e2fsck_t ctx, struct problem_context *pctx);
> +struct encrypted_file *find_encrypted_file(e2fsck_t ctx, ext2_ino_t ino);=

> +int encryption_policies_consistent(const struct encrypted_file *file_a,
> +                   const struct encrypted_file *file_b);
> +void destroy_encrypted_files(e2fsck_t ctx);
> +
> +/* extents.c */
> errcode_t e2fsck_rebuild_extents_later(e2fsck_t ctx, ext2_ino_t ino);
> int e2fsck_ino_will_be_rebuilt(e2fsck_t ctx, ext2_ino_t ino);
> void e2fsck_pass1e(e2fsck_t ctx);
> diff --git a/e2fsck/encrypted_files.c b/e2fsck/encrypted_files.c
> new file mode 100644
> index 00000000..57522950
> --- /dev/null
> +++ b/e2fsck/encrypted_files.c
> @@ -0,0 +1,187 @@
> +/*
> + * encrypted_files.c --- save information about encrypted files
> + *
> + * Copyright 2019 Google LLC
> + *
> + * %Begin-Header%
> + * This file may be redistributed under the terms of the GNU Public
> + * License.
> + * %End-Header%
> + */
> +
> +#include "config.h"
> +
> +#include "e2fsck.h"
> +#include "problem.h"
> +
> +#define FS_ENCRYPTION_CONTEXT_FORMAT_V1        1
> +#define FS_KEY_DESCRIPTOR_SIZE            8
> +#define FS_KEY_DERIVATION_NONCE_SIZE        16
> +
> +/* Format of encryption xattr (v1) */
> +struct fscrypt_context {
> +    __u8 format;
> +    __u8 contents_encryption_mode;
> +    __u8 filenames_encryption_mode;
> +    __u8 flags;
> +    __u8 master_key_descriptor[FS_KEY_DESCRIPTOR_SIZE];
> +    __u8 nonce[FS_KEY_DERIVATION_NONCE_SIZE];
> +};
> +
> +static errcode_t get_encryption_xattr(e2fsck_t ctx, ext2_ino_t ino,
> +                      void **value, size_t *value_len)
> +{
> +    struct ext2_xattr_handle *h;
> +    errcode_t retval;
> +
> +    retval =3D ext2fs_xattrs_open(ctx->fs, ino, &h);
> +    if (retval)
> +        return retval;
> +
> +    retval =3D ext2fs_xattrs_read(h);
> +    if (retval =3D=3D 0)
> +        retval =3D ext2fs_xattr_get(h, "c", value, value_len);
> +
> +    ext2fs_xattrs_close(&h);
> +    return retval;
> +}
> +
> +/*
> + * Return true if the encryption xattr might be valid.  Don't be too stri=
ct
> + * here, since there may be new versions of the encryption xattr in the f=
uture.
> + * Assume that an xattr with an unknown version number (other than 0) is v=
alid.
> + */
> +static int possibly_valid_encryption_xattr(const void *value, size_t valu=
e_len)
> +{
> +    const struct fscrypt_context *ctx =3D value;
> +
> +    if (value_len < 1)
> +        return 0;
> +
> +    if (ctx->format !=3D FS_ENCRYPTION_CONTEXT_FORMAT_V1)
> +        return ctx->format !=3D 0;
> +
> +    return value_len =3D=3D sizeof(*ctx);
> +}
> +
> +/*
> + * Add the inode 'pctx->ino' to the encrypted_files map and save its encr=
yption
> + * xattr.  If the encryption xattr isn't valid, offer to clear the inode.=

> + *
> + * This must be called with increasing inode numbers.
> + *
> + * Returns -1 if the inode should be cleared, otherwise 0.
> + */
> +int add_encrypted_file(e2fsck_t ctx, struct problem_context *pctx)
> +{
> +    struct encrypted_files *files =3D &ctx->encrypted_files;
> +    ext2_ino_t ino =3D pctx->ino;
> +    struct encrypted_file *file;
> +    errcode_t retval;
> +
> +    if (files->count =3D=3D files->capacity) {
> +        size_t new_capacity =3D files->capacity * 2;
> +
> +        if (new_capacity < 128)
> +            new_capacity =3D 128;
> +
> +        retval =3D ext2fs_resize_mem(files->capacity * sizeof(*file),
> +                       new_capacity * sizeof(*file),
> +                       &files->files);
> +        if (retval) {
> +            fix_problem(ctx, PR_1_ALLOCATE_ENCRYPTED_DIRLIST, pctx);
> +            /* Should never get here */
> +            ctx->flags |=3D E2F_FLAG_ABORT;
> +            return -1;
> +        }
> +        files->capacity =3D new_capacity;
> +    }
> +
> +    if (files->count > 0 && ino <=3D files->files[files->count - 1].ino)
> +        /* Should never get here */
> +        fatal_error(ctx, "Encrypted inodes processed out of order");
> +
> +    file =3D &files->files[files->count++];
> +    file->ino =3D ino;
> +    file->xattr_value =3D NULL;
> +    file->xattr_size =3D 0;
> +
> +    pctx->errcode =3D get_encryption_xattr(ctx, ino, &file->xattr_value,
> +                         &file->xattr_size);
> +    if (pctx->errcode) {
> +        if (fix_problem(ctx, PR_1_MISSING_ENCRYPTION_XATTR, pctx))
> +            return -1;
> +    } else if (!possibly_valid_encryption_xattr(file->xattr_value,
> +                            file->xattr_size)) {
> +        ext2fs_free_mem(&file->xattr_value);
> +        file->xattr_size =3D 0;
> +        if (fix_problem(ctx, PR_1_CORRUPT_ENCRYPTION_XATTR, pctx))
> +            return -1;
> +    }
> +    return 0;
> +}
> +
> +/*
> + * Find the given inode in the encrypted_files map.
> + *
> + * Returns the encrypted_file if found, otherwise NULL.
> + */
> +struct encrypted_file *find_encrypted_file(e2fsck_t ctx, ext2_ino_t ino)
> +{
> +    struct encrypted_files *files =3D &ctx->encrypted_files;
> +    size_t l =3D 0;
> +    size_t r =3D files->count;
> +
> +    while (l < r) {
> +        size_t m =3D l + (r - l) / 2;
> +        struct encrypted_file *file =3D &files->files[m];
> +
> +        if (ino < file->ino)
> +            r =3D m;
> +        else if (ino > file->ino)
> +            l =3D m + 1;
> +        else
> +            return file;
> +    }
> +    return NULL;
> +}
> +
> +/*
> + * Return true if the given two files might have the same encryption poli=
cy.
> + * Return false if they definitely don't.
> + */
> +int encryption_policies_consistent(const struct encrypted_file *file_a,
> +                   const struct encrypted_file *file_b)
> +{
> +    const struct fscrypt_context *ctx_a =3D file_a->xattr_value;
> +    const struct fscrypt_context *ctx_b =3D file_b->xattr_value;
> +
> +    if (file_a->xattr_size < 1 || file_b->xattr_size < 1)
> +        return 0; /* missing or corrupt */
> +
> +    if (ctx_a->format !=3D ctx_b->format)
> +        return 0; /* different formats, so different policies */
> +
> +    if (ctx_a->format !=3D FS_ENCRYPTION_CONTEXT_FORMAT_V1)
> +        return 1; /* unrecognized format, so not sure */
> +
> +    return ctx_a->contents_encryption_mode =3D=3D
> +        ctx_b->contents_encryption_mode &&
> +           ctx_a->filenames_encryption_mode =3D=3D
> +        ctx_b->filenames_encryption_mode &&
> +           ctx_a->flags =3D=3D ctx_b->flags &&
> +           memcmp(ctx_a->master_key_descriptor,
> +              ctx_b->master_key_descriptor,
> +              FS_KEY_DESCRIPTOR_SIZE) =3D=3D 0;
> +}
> +
> +void destroy_encrypted_files(e2fsck_t ctx)
> +{
> +    struct encrypted_files *files =3D &ctx->encrypted_files;
> +    size_t i;
> +
> +    for (i =3D 0; i < files->count; i++)
> +        ext2fs_free_mem(&files->files[i].xattr_value);
> +    ext2fs_free_mem(&files->files);
> +    memset(files, 0, sizeof(*files));
> +}
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index 524577ae..f92420e8 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -27,6 +27,7 @@
>  *    - A bitmap of which blocks are in use by two inodes    (block_dup_ma=
p)
>  *    - The data blocks of the directory inodes.    (dir_map)
>  *    - Ref counts for ea_inodes.            (ea_inode_refs)
> + *    - Encrypted inodes and their encryption xattrs.    (encrypted_files=
)
>  *
>  * Pass 1 is designed to stash away enough information so that the
>  * other passes should not need to read in the inode information
> @@ -78,7 +79,6 @@ static void mark_table_blocks(e2fsck_t ctx);
> static void alloc_bb_map(e2fsck_t ctx);
> static void alloc_imagic_map(e2fsck_t ctx);
> static void mark_inode_bad(e2fsck_t ctx, ino_t ino);
> -static void add_encrypted_dir(e2fsck_t ctx, ino_t ino);
> static void handle_fs_bad_blocks(e2fsck_t ctx);
> static void process_inodes(e2fsck_t ctx, char *block_buf);
> static EXT2_QSORT_TYPE process_inode_cmp(const void *a, const void *b);
> @@ -1871,12 +1871,14 @@ void e2fsck_pass1(e2fsck_t ctx)
>            failed_csum =3D 0;
>        }
>=20
> +        if ((inode->i_flags & EXT4_ENCRYPT_FL) &&
> +            add_encrypted_file(ctx, &pctx) < 0)
> +            goto clear_inode;
> +
>        if (LINUX_S_ISDIR(inode->i_mode)) {
>            ext2fs_mark_inode_bitmap2(ctx->inode_dir_map, ino);
>            e2fsck_add_dir_info(ctx, ino, 0);
>            ctx->fs_directory_count++;
> -            if (inode->i_flags & EXT4_ENCRYPT_FL)
> -                add_encrypted_dir(ctx, ino);
>        } else if (LINUX_S_ISREG (inode->i_mode)) {
>            ext2fs_mark_inode_bitmap2(ctx->inode_reg_map, ino);
>            ctx->fs_regular_count++;
> @@ -2189,24 +2191,6 @@ static void mark_inode_bad(e2fsck_t ctx, ino_t ino)=

>    ext2fs_mark_inode_bitmap2(ctx->inode_bad_map, ino);
> }
>=20
> -static void add_encrypted_dir(e2fsck_t ctx, ino_t ino)
> -{
> -    struct        problem_context pctx;
> -
> -    if (!ctx->encrypted_dirs) {
> -        pctx.errcode =3D ext2fs_u32_list_create(&ctx->encrypted_dirs, 0);=

> -        if (pctx.errcode)
> -            goto error;
> -    }
> -    pctx.errcode =3D ext2fs_u32_list_add(ctx->encrypted_dirs, ino);
> -    if (pctx.errcode =3D=3D 0)
> -        return;
> -error:
> -    fix_problem(ctx, PR_1_ALLOCATE_ENCRYPTED_DIRLIST, &pctx);
> -    /* Should never get here */
> -    ctx->flags |=3D E2F_FLAG_ABORT;
> -}
> -
> /*
>  * This procedure will allocate the inode "bb" (badblock) map table
>  */
> diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
> index 8b40e93d..2f4c64c0 100644
> --- a/e2fsck/pass2.c
> +++ b/e2fsck/pass2.c
> @@ -35,10 +35,12 @@
>  *    - The inode_used_map bitmap
>  *    - The inode_bad_map bitmap
>  *    - The inode_dir_map bitmap
> + *    - The encrypted_files map
>  *
>  * Pass 2 frees the following data structures
>  *    - The inode_bad_map bitmap
>  *    - The inode_reg_map bitmap
> + *    - The encrypted_files map
>  */
>=20
> #define _GNU_SOURCE 1 /* get strnlen() */
> @@ -284,10 +286,7 @@ void e2fsck_pass2(e2fsck_t ctx)
>        ext2fs_free_inode_bitmap(ctx->inode_reg_map);
>        ctx->inode_reg_map =3D 0;
>    }
> -    if (ctx->encrypted_dirs) {
> -        ext2fs_u32_list_free(ctx->encrypted_dirs);
> -        ctx->encrypted_dirs =3D 0;
> -    }
> +    destroy_encrypted_files(ctx);
>=20
>    clear_problem_context(&pctx);
>    if (ctx->large_files) {
> @@ -877,6 +876,71 @@ err:
>    return retval;
> }
>=20
> +/* Return true if this type of file needs encryption */
> +static int needs_encryption(e2fsck_t ctx, const struct ext2_dir_entry *di=
rent)
> +{
> +    int filetype =3D ext2fs_dirent_file_type(dirent);
> +    ext2_ino_t ino =3D dirent->inode;
> +    struct ext2_inode inode;
> +
> +    if (filetype !=3D EXT2_FT_UNKNOWN)
> +        return filetype =3D=3D EXT2_FT_REG_FILE ||
> +               filetype =3D=3D EXT2_FT_DIR ||
> +               filetype =3D=3D EXT2_FT_SYMLINK;
> +
> +    if (ext2fs_test_inode_bitmap2(ctx->inode_reg_map, ino) ||
> +        ext2fs_test_inode_bitmap2(ctx->inode_dir_map, ino))
> +        return 1;
> +
> +    e2fsck_read_inode(ctx, ino, &inode, "check_encryption_policy");
> +    return LINUX_S_ISREG(inode.i_mode) ||
> +           LINUX_S_ISDIR(inode.i_mode) ||
> +           LINUX_S_ISLNK(inode.i_mode);
> +}
> +
> +/*
> + * All regular files, directories, and symlinks in encrypted directories m=
ust be
> + * encrypted using the same encryption policy as their directory.
> + */
> +static int check_encryption_policy(e2fsck_t ctx,
> +                   struct ext2_dir_entry *dirent,
> +                   const struct encrypted_file *dir_encinfo,
> +                   struct problem_context *pctx)
> +{
> +    const struct encrypted_file *file_encinfo;
> +
> +    file_encinfo =3D find_encrypted_file(ctx, dirent->inode);
> +    if (file_encinfo) {
> +        if (!encryption_policies_consistent(dir_encinfo,
> +                            file_encinfo)) {
> +            if (fix_problem(ctx,
> +                    PR_2_INCONSISTENT_ENCRYPTION_POLICY,
> +                    pctx)) {
> +                dirent->inode =3D 0;
> +                return 1;
> +            }
> +        }
> +    } else if (needs_encryption(ctx, dirent)) {
> +        if (fix_problem(ctx, PR_2_UNENCRYPTED_FILE, pctx)) {
> +            dirent->inode =3D 0;
> +            return 1;
> +        }
> +    }
> +    return 0;
> +}
> +
> +static int check_encrypted_dirent(e2fsck_t ctx,
> +                  struct ext2_dir_entry *dirent,
> +                  const struct encrypted_file *dir_encinfo,
> +                  struct problem_context *pctx)
> +{
> +    if (encrypted_check_name(ctx, dirent, pctx))
> +        return 1;
> +    if (check_encryption_policy(ctx, dirent, dir_encinfo, pctx))
> +        return 1;
> +    return 0;
> +}
> +
> static int check_dir_block2(ext2_filsys fs,
>               struct ext2_db_entry2 *db,
>               void *priv_data)
> @@ -931,7 +995,7 @@ static int check_dir_block(ext2_filsys fs,
>    int    is_leaf =3D 1;
>    size_t    inline_data_size =3D 0;
>    int    filetype =3D 0;
> -    int    encrypted =3D 0;
> +    const struct encrypted_file *dir_encinfo =3D NULL;
>    size_t    max_block_size;
>    int    hash_flags =3D 0;
>=20
> @@ -1150,8 +1214,7 @@ skip_checksum:
>    } else
>        max_block_size =3D fs->blocksize - de_csum_size;
>=20
> -    if (ctx->encrypted_dirs)
> -        encrypted =3D ext2fs_u32_list_test(ctx->encrypted_dirs, ino);
> +    dir_encinfo =3D find_encrypted_file(ctx, ino);
>=20
>    dict_init(&de_dict, DICTCOUNT_T_MAX, dict_de_cmp);
>    prev =3D 0;
> @@ -1415,18 +1478,21 @@ skip_checksum:
>            }
>        }
>=20
> -        if (!encrypted && check_name(ctx, dirent, &cd->pctx))
> +        if (check_filetype(ctx, dirent, ino, &cd->pctx))
>            dir_modified++;
>=20
> -        if (encrypted && (dot_state) > 1 &&
> -            encrypted_check_name(ctx, dirent, &cd->pctx)) {
> -            dir_modified++;
> -            goto next;
> +        if (dir_encinfo) { /* Encrypted directory? */
> +            if (dot_state > 1 &&
> +                check_encrypted_dirent(ctx, dirent, dir_encinfo,
> +                           &cd->pctx)) {
> +                dir_modified++;
> +                goto next;
> +            }
> +        } else {
> +            if (check_name(ctx, dirent, &cd->pctx))
> +                dir_modified++;
>        }
>=20
> -        if (check_filetype(ctx, dirent, ino, &cd->pctx))
> -            dir_modified++;
> -
>        if (dx_db) {
>            if (dx_dir->casefolded_hash)
>                hash_flags =3D EXT4_CASEFOLD_FL;
> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> index c45c6b78..4ddd748a 100644
> --- a/e2fsck/problem.c
> +++ b/e2fsck/problem.c
> @@ -1240,6 +1240,15 @@ static struct e2fsck_problem problem_table[] =3D {
>      N_("EA @i %N for parent @i %i missing EA_INODE flag.\n "),
>      PROMPT_FIX, PR_PREEN_OK, 0, 0, 0 },
>=20
> +    /* Encrypted inode is missing encryption xattr */
> +    { PR_1_MISSING_ENCRYPTION_XATTR,
> +      N_("Encrypted @i %i is missing encryption @a.\n"),
> +      PROMPT_CLEAR_INODE, 0, 0, 0, 0 },
> +
> +    /* Encrypted inode has corrupt encryption xattr */
> +    { PR_1_CORRUPT_ENCRYPTION_XATTR,
> +      N_("Encrypted @i %i has corrupt encryption @a.\n"),
> +      PROMPT_CLEAR_INODE, 0, 0, 0, 0 },
>=20
>    /* Pass 1b errors */
>=20
> @@ -1767,6 +1776,16 @@ static struct e2fsck_problem problem_table[] =3D {
>      N_("Encrypted @E is too short.\n"),
>      PROMPT_CLEAR, 0, 0, 0, 0 },
>=20
> +    /* Encrypted directory contains unencrypted file */
> +    { PR_2_UNENCRYPTED_FILE,
> +      N_("Encrypted @E references unencrypted @i %Di.\n"),
> +      PROMPT_CLEAR, 0, 0, 0, 0 },
> +
> +    /* Encrypted directory contains file with different encryption policy=
 */
> +    { PR_2_INCONSISTENT_ENCRYPTION_POLICY,
> +      N_("Encrypted @E references @i %Di, which has a different encryptio=
n policy.\n"),
> +      PROMPT_CLEAR, 0, 0, 0, 0 },
> +
>    /* Pass 3 errors */
>=20
>    /* Pass 3: Checking directory connectivity */
> diff --git a/e2fsck/problem.h b/e2fsck/problem.h
> index 2c79169e..e3c59bb6 100644
> --- a/e2fsck/problem.h
> +++ b/e2fsck/problem.h
> @@ -693,6 +693,11 @@ struct problem_context {
> /* EA inode for parent inode does not have EXT4_EA_INODE_FL flag */
> #define PR_1_ATTR_SET_EA_INODE_FL        0x010086
>=20
> +/* Encrypted inode is missing encryption xattr */
> +#define PR_1_MISSING_ENCRYPTION_XATTR 0x010087
> +
> +/* Encrypted inode has corrupt encryption xattr */
> +#define PR_1_CORRUPT_ENCRYPTION_XATTR        0x010088
>=20
> /*
>  * Pass 1b errors
> @@ -1009,6 +1014,12 @@ struct problem_context {
> /* Encrypted directory entry is too short */
> #define PR_2_BAD_ENCRYPTED_NAME        0x020050
>=20
> +/* Encrypted directory contains unencrypted file */
> +#define PR_2_UNENCRYPTED_FILE        0x020051
> +
> +/* Encrypted directory contains file with different encryption policy */
> +#define PR_2_INCONSISTENT_ENCRYPTION_POLICY    0x020052
> +
> /*
>  * Pass 3 errors
>  */
> diff --git a/po/POTFILES.in b/po/POTFILES.in
> index d6b4f433..f5b5936e 100644
> --- a/po/POTFILES.in
> +++ b/po/POTFILES.in
> @@ -5,6 +5,7 @@ e2fsck/e2fsck.c
> e2fsck/ea_refcount.c
> e2fsck/ehandler.c
> e2fsck/emptydir.c
> +e2fsck/encrypted_files.c
> e2fsck/extend.c
> e2fsck/extents.c
> e2fsck/flushb.c
> diff --git a/tests/f_bad_encryption/expect.1 b/tests/f_bad_encryption/expe=
ct.1
> new file mode 100644
> index 00000000..20c5af73
> --- /dev/null
> +++ b/tests/f_bad_encryption/expect.1
> @@ -0,0 +1,108 @@
> +Pass 1: Checking inodes, blocks, and sizes
> +Encrypted inode 17 is missing encryption extended attribute.
> +Clear inode? yes
> +
> +Encrypted inode 18 is missing encryption extended attribute.
> +Clear inode? yes
> +
> +Encrypted inode 19 has corrupt encryption extended attribute.
> +Clear inode? yes
> +
> +Encrypted inode 20 has corrupt encryption extended attribute.
> +Clear inode? yes
> +
> +Pass 2: Checking directory structure
> +Entry '^?M-}^]M-^NSM-^SM-^LM-^RM-AM-{M-=3DM-TM-^MM-UM-VM-UM-^^^FEM-e' in /=
edir (12) has deleted/unused inode 17.  Clear? yes
> +
> +Entry '>/M-^ZM-z:M-B1M-8^B7M-NM-^MsM-CajM-m^KM-.M-+' in /edir (12) has de=
leted/unused inode 18.  Clear? yes
> +
> +Entry 'M-<M-^GM-rM-^N^OM-^R-M-l^SwG^M-^_y^GM-*' in /edir (12) has deleted=
/unused inode 19.  Clear? yes
> +
> +Entry 'MM- M-FNM-^^/M-a^F^BM-!IM-]CM-VM-G^W' in /edir (12) has deleted/un=
used inode 20.  Clear? yes
> +
> +Encrypted entry 'M-^DM-xM-^K2M-vM-c^E3vM-~^ZM-/M-iM-sq^P' in /edir (12) r=
eferences unencrypted inode 21.
> +Clear? yes
> +
> +Encrypted entry 'M-8^RU)VM-wM-}<M-^EM-P^HM-@2\4M-)' in /edir (12) referen=
ces unencrypted inode 22.
> +Clear? yes
> +
> +Encrypted entry 'n^VcM-`e^\M-=3DM-M[-M-xM-SM-gM-^AM-YM-N,M-8M-^CM-T' in /=
edir (12) references unencrypted inode 23.
> +Clear? yes
> +
> +Encrypted entry 'M-CM-];:^Q^W^CM->M-g^_M-_M-(M-^LF^N^PM-^D'T^Q' in /edir (=
12) references inode 24, which has a different encryption policy.
> +Clear? yes
> +
> +Encrypted entry 'M-#@<M-)chM-rM-<Y]M-^MM-(M->dM-^NM-z' in /edir (12) refe=
rences inode 25, which has a different encryption policy.
> +Clear? yes
> +
> +Encrypted entry 'VM-^_M-6M-gM-jM-6M-^JM-^OM-r]M-X^I^RM-AyM-^^DM-^_M-QR' i=
n /edir (12) references inode 26, which has a different encryption policy.
> +Clear? yes
> +
> +Encrypted entry 'f#M-^SUM-^IM-u8M-_M-BW^YM-^UBM-#$;M-^D'T^Q' in /edir (12=
) references inode 27, which has a different encryption policy.
> +Clear? yes
> +
> +Pass 3: Checking directory connectivity
> +Unconnected directory inode 22 (/edir/???)
> +Connect to /lost+found? yes
> +
> +Unconnected directory inode 25 (/edir/???)
> +Connect to /lost+found? yes
> +
> +Pass 4: Checking reference counts
> +Inode 12 ref count is 4, should be 3.  Fix? yes
> +
> +Unattached inode 21
> +Connect to /lost+found? yes
> +
> +Inode 21 ref count is 2, should be 1.  Fix? yes
> +
> +Inode 22 ref count is 3, should be 2.  Fix? yes
> +
> +Unattached inode 23
> +Connect to /lost+found? yes
> +
> +Inode 23 ref count is 2, should be 1.  Fix? yes
> +
> +Unattached inode 24
> +Connect to /lost+found? yes
> +
> +Inode 24 ref count is 2, should be 1.  Fix? yes
> +
> +Inode 25 ref count is 3, should be 2.  Fix? yes
> +
> +Unattached inode 26
> +Connect to /lost+found? yes
> +
> +Inode 26 ref count is 2, should be 1.  Fix? yes
> +
> +Unattached inode 27
> +Connect to /lost+found? yes
> +
> +Inode 27 ref count is 2, should be 1.  Fix? yes
> +
> +Pass 5: Checking group summary information
> +Block bitmap differences:  -(21--28)
> +Fix? yes
> +
> +Free blocks count wrong for group #0 (87, counted=3D95).
> +Fix? yes
> +
> +Free blocks count wrong (87, counted=3D95).
> +Fix? yes
> +
> +Inode bitmap differences:  -(17--20)
> +Fix? yes
> +
> +Free inodes count wrong for group #0 (101, counted=3D105).
> +Fix? yes
> +
> +Directories count wrong for group #0 (7, counted=3D6).
> +Fix? yes
> +
> +Free inodes count wrong (101, counted=3D105).
> +Fix? yes
> +
> +
> +test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
> +test_filesys: 23/128 files (0.0% non-contiguous), 33/128 blocks
> +Exit status is 1
> diff --git a/tests/f_bad_encryption/expect.2 b/tests/f_bad_encryption/expe=
ct.2
> new file mode 100644
> index 00000000..30a0badc
> --- /dev/null
> +++ b/tests/f_bad_encryption/expect.2
> @@ -0,0 +1,7 @@
> +Pass 1: Checking inodes, blocks, and sizes
> +Pass 2: Checking directory structure
> +Pass 3: Checking directory connectivity
> +Pass 4: Checking reference counts
> +Pass 5: Checking group summary information
> +test_filesys: 23/128 files (0.0% non-contiguous), 33/128 blocks
> +Exit status is 0
> diff --git a/tests/f_bad_encryption/image.gz b/tests/f_bad_encryption/imag=
e.gz
> new file mode 100644
> index 0000000000000000000000000000000000000000..dc36bd6e97f056536c2418a18a=
e522db97205709
> GIT binary patch
> literal 2009
> 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
> BcYpu@
>=20
> literal 0
> HcmV?d00001
>=20
> diff --git a/tests/f_bad_encryption/mkimage.sh b/tests/f_bad_encryption/mk=
image.sh
> new file mode 100755
> index 00000000..d3c34633
> --- /dev/null
> +++ b/tests/f_bad_encryption/mkimage.sh
> @@ -0,0 +1,140 @@
> +#!/bin/bash
> +#
> +# This is the script that was used to create the image.gz in this directo=
ry.
> +#
> +# This requires a patched version of debugfs that understands the "fscryp=
t."
> +# xattr name prefix, so that the encryption xattrs can be manipulated.
> +
> +set -e -u
> +umask 0022
> +
> +do_debugfs() {
> +    umount mnt
> +    debugfs -w "$@" image
> +    mount image mnt
> +}
> +
> +create_encrypted_file() {
> +    local file=3D$1
> +    local ino
> +
> +    echo foo > "$file"
> +
> +    # not needed, but makes image more compressible
> +    ino=3D$(stat -c %i "$file")
> +    do_debugfs -R "zap_block -f <$ino> 0"
> +}
> +
> +set_encryption_xattr() {
> +    local file=3D$1
> +    local value=3D$2
> +    local ino
> +
> +    ino=3D$(stat -c %i "$file")
> +    do_debugfs -R "ea_set <$ino> fscrypt.c $value"
> +}
> +
> +rm_encryption_xattr() {
> +    local file=3D$1
> +    local ino
> +
> +    ino=3D$(stat -c %i "$file")
> +    do_debugfs -R "ea_rm <$ino> fscrypt.c"
> +}
> +
> +clear_encrypt_flag() {
> +    local file=3D$1
> +    local ino
> +
> +    ino=3D$(stat -c %i "$file")
> +    do_debugfs -R "set_inode_field <$ino> flags 0"
> +}
> +
> +clear_encryption() {
> +    local file=3D$1
> +    local ino
> +    local is_symlink=3Dfalse
> +
> +    if [ -L "$file" ]; then
> +        is_symlink=3Dtrue
> +    fi
> +    ino=3D$(stat -c %i "$file")
> +
> +    do_debugfs -R "ea_rm <$ino> fscrypt.c"
> +    do_debugfs -R "set_inode_field <$ino> flags 0"
> +    if $is_symlink; then
> +        do_debugfs -R "set_inode_field <$ino> block[0] 0xAAAAAAAA"
> +        do_debugfs -R "set_inode_field <$ino> block[1] 0"
> +        do_debugfs -R "set_inode_field <$ino> size 4"
> +    fi
> +}
> +
> +mkdir -p mnt
> +umount mnt &> /dev/null || true
> +
> +dd if=3D/dev/zero of=3Dimage bs=3D4096 count=3D128
> +mke2fs -O encrypt -b 4096 -N 128 image
> +mount image mnt
> +
> +# Create an encrypted directory (ino 12)
> +dir=3Dmnt/edir
> +mkdir $dir
> +echo password | e4crypt add_key $dir
> +
> +# Control cases: valid encrypted regular file, dir, and symlink (ino 13-1=
5)
> +create_encrypted_file $dir/encrypted_file
> +mkdir $dir/encrypted_dir
> +ln -s target $dir/encrypted_symlink
> +
> +# Control case: file type that is never encrypted (ino 16)
> +mkfifo $dir/fifo
> +
> +# Inodes with missing or corrupt encryption xattr (ino 17-20).
> +# e2fsck should offer to clear these inodes.
> +
> +create_encrypted_file $dir/missing_xattr_file
> +rm_encryption_xattr $dir/missing_xattr_file
> +
> +mkdir $dir/missing_xattr_dir
> +rm_encryption_xattr $dir/missing_xattr_dir
> +
> +create_encrypted_file $dir/corrupt_xattr_1
> +set_encryption_xattr $dir/corrupt_xattr_1 '\0'
> +
> +create_encrypted_file $dir/corrupt_xattr_2
> +set_encryption_xattr $dir/corrupt_xattr_2 \
> +    '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0'
> +
> +# Unencrypted inodes in encrypted directory (ino 21-23).
> +# e2fsck should offer to clear these directory entries.
> +
> +create_encrypted_file $dir/unencrypted_file
> +clear_encryption $dir/unencrypted_file
> +
> +mkdir $dir/unencrypted_dir
> +clear_encryption $dir/unencrypted_dir
> +
> +ln -s target $dir/unencrypted_symlink
> +clear_encryption $dir/unencrypted_symlink
> +
> +# Inodes with different encryption policy in encrypted directory (ino 24-=
27).
> +# e2fsck should offer to clear these directory entries.
> +
> +xattr=3D'\1\1\4\0AAAAAAAAAAAAAAAAAAAAAAAA'
> +
> +create_encrypted_file $dir/inconsistent_file_1
> +set_encryption_xattr $dir/inconsistent_file_1 $xattr
> +
> +mkdir $dir/inconsistent_dir
> +set_encryption_xattr $dir/inconsistent_dir $xattr
> +
> +ln -s target $dir/inconsistent_symlink
> +set_encryption_xattr $dir/inconsistent_symlink $xattr
> +
> +xattr=3D'\2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
> +create_encrypted_file $dir/inconsistent_file_2
> +set_encryption_xattr $dir/inconsistent_file_2 $xattr
> +
> +umount mnt
> +rmdir mnt
> +gzip -9 -f image
> diff --git a/tests/f_bad_encryption/name b/tests/f_bad_encryption/name
> new file mode 100644
> index 00000000..85b19eda
> --- /dev/null
> +++ b/tests/f_bad_encryption/name
> @@ -0,0 +1 @@
> +missing, corrupt, and inconsistent encryption policies
> diff --git a/tests/f_short_encrypted_dirent/expect.1 b/tests/f_short_encry=
pted_dirent/expect.1
> index bc649222..29e1625c 100644
> --- a/tests/f_short_encrypted_dirent/expect.1
> +++ b/tests/f_short_encrypted_dirent/expect.1
> @@ -13,5 +13,5 @@ Inode 13 ref count is 2, should be 1.  Fix? yes
> Pass 5: Checking group summary information
>=20
> test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
> -test_filesys: 13/16 files (0.0% non-contiguous), 23/100 blocks
> +test_filesys: 13/16 files (0.0% non-contiguous), 24/100 blocks
> Exit status is 1
> diff --git a/tests/f_short_encrypted_dirent/expect.2 b/tests/f_short_encry=
pted_dirent/expect.2
> index 636c6e9e..1ebd598e 100644
> --- a/tests/f_short_encrypted_dirent/expect.2
> +++ b/tests/f_short_encrypted_dirent/expect.2
> @@ -3,5 +3,5 @@ Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> -test_filesys: 13/16 files (0.0% non-contiguous), 23/100 blocks
> +test_filesys: 13/16 files (0.0% non-contiguous), 24/100 blocks
> Exit status is 0
> diff --git a/tests/f_short_encrypted_dirent/image.gz b/tests/f_short_encry=
pted_dirent/image.gz
> index a35bfb23b51aee75da142886a39380915d629f8e..7eb1c951f4e747c72a8245e5ca=
040ab07828a632 100644
> GIT binary patch
> delta 967
> zcmV;&133Jh2k-}fABzYG?<+1{0t0DnVP|Ck?c7ah9Ay{);F--9>b8|y<Ih3b(Sj|p
> zCOrrhD$<C>OK72OkorU2>`s!Qo85GGVjHd4A_(e5JxI@@w&2f65ig>mQt=3D`RrJ@!O
> zT0|_i=3Dt0yHXE#Z$HdVCZHp%nAo6OF9Gw(Ma-}_An>;wUSFkdarqMXHoEc&wO$Ra$u
> zK{Odlr#^<)ci$TX6BAp%4_oby<PP;uH=3DRCjQ5O5MxH*e=3Da$&GD9|TW~{PNm{XEt=3Dc
> zwD;q?uKJ|w&34@D#w&Myw6|yD@>f>%jf_8aU}qR?2o_HrJNrKVOW_Rr^4ZR1b9hdL
> zd37}#Jbmqd^Xr=3DRet8xvTlL@3s{f|9N1uG4BY6D5^PPKO>8{U=3DAk1zP6D!U<1Am$T
> z=3D964j_ltut*PZ>I+|K2?yC?sK?+gmLO0ALJFjyO_mV?$hak!(98;a8%jp1579Ur%V
> z!Yq{4^0B+`yKZdJpX&dcj>-B5=3D63x*^5N@;n%h5rb{G$sZ}orr=3DYf0FKd65|{R8SB
> zQ2&7X2h=3D~H{sHw5sDEH~);}<B*MS+o|F<OD{=3D6d}j?~h!QG&Vm{QvUAyV1l7-+_kt
> zs<3T1jz;UXp?Yzo5hc}9Wvm>Rquoh59HrTz+v9<xSdH%3)Zf#WRLAy2jqyerk3_|K
> z91Yfg<2Y*62GiZyr}c$q^LS6Olt$&Gk=3DB!eu{5bwqcpB(S01d@qqtZap3c>}Ksj!d
> zvUXX%q}t3@NUG)J{-iustVDxJC2n>o>KSX)dm6)8`<`;G)YH{ds*R4<lcC|XyHGf%
> zd!^b)c3P|Zy|-=3DM+}FQtW8d~@)8^>T-Yr{ydN*y`z9vd*(PUTCxSAG5v+gBnn)P8|
> zJSvWkR+3V2pb|%w;_mK(=3DLB<I?%U=3D&>YB0l;KPsY`EK<WXCDnO`KtBb!E2_Dmkb!p
> zDq)xpx{iK&c+Jt1$5x~-uWzh+|M=3D;32cJE)@OYQe0RR910000000000fQ#Re+@bz|
> z>G;2LzPKX@PV{CQ`I++PTkj(Yf`zT0g&)FZvopfU(=3DN!PzqWVGSFUbv{{1(#H-GO3
> z?ahDkjUd>!KigQF&!0R0!m0W9?_Ksc$A?~M@BP2Juf6%xhuWL}y(K~LR&)JXJJb4;
> z3$Ff)^{4sXqy-n4f7z|SuYX@>d8cD7I)5wQ!t<|x%l<*GD`wbt<1In(TsHrgXBRt_
> p<(-Z{&j0i0@4UeKKX9q%E|XycFOzTs4-8yPeggtG1iAo_0RSAO3C;ij
>=20
> delta 884
> zcmV-)1B?9d2b~9hABzY8%mk=3Da0t4;bO^6#+902giN1>#x)^$-&b+8Ae>ZS(|f*@V7
> zh_G&<?NX{j%_g(EL$k>?nb@vWXc4@4Q4s0DqsodOCq?uiA_|HiqEL{EcoDo56+QUL
> z`jYI{YPSlm7`OZT!9RJEc{Bev!~4I<C5a+nz1kY07Ggtxh<id5Lgdcx5cgy2(&pWT
> zg^4IyT-^6{uGjB$zPsJGeB7oGCqmpB;_ZAcI$VsR$7X+ib=3DOn7hF?7X@x51nvg6G`
> zT<h+uj(l{yynEZr*N@H4KXK}CF4`4sUfOs5b^M!hD|}WA9}Zo@b1GL<S8Kt6PoICf
> zTkltf*xsvu|3a_+yT)#Q{Gmeh#*Y^}_N6C}oN)(XZChNt{M<9}hecpL$%ne%9Od#O
> z;l1C^=3DSN2R-{FU&Qoi17XE#nYJB?b@TPNNtl=3D9O_cBnnmY-RKF7EoA&LM?xO-vifm
> zHvOsozbf?WAGoyZ|B(+~Tj;jGFSsAD-s=3DC?pC<2rSO1{?0rd~4e?a{M>K{=3D5fcgj2
> zKcN1BwORkbx?KlW{QcjS(EhAY%*{5ln!5y--t+&9v+u-<*ZK`KtXHM|Gf6zxYEHK*
> zv+X!-RO_8uQj3qK*-V^;U3VsvX{8b0H9k=3DuOB<bIaeKa<C9`p*mBdr6B#GP2sqARj
> zx~<fI?VcQ~RI|92wzF0`*~!voBhHdmIP+Aq6(^PI%yO>Y32I5Z8v2ENX``F1ls0PV
> zgK4c(smD`kJ?Rc8E_d3ka(gE9FV~vY@{V$~IXB-*r)RQ}Qt5)>RhzTnu-@=3DT@7T9z
> zY-0cJv4ipWp7_A%-o2ya`w!j}XU(`j)GTR#WTm+<yfn+g7$)cA%G_K%tyU)MNnEcS
> z9VvNE000000000000000001x;r}GOF%kf|3eBn?OogEF0;!638z5gSLqK&=3DR(s#LT
> zw{vp+!&c?dUj}>6x8E?>{3mZ2Z2r;r2b=3D$!*Q4mf$<WwYEM7SOa!d2?pS$93_D?@q
> zH`wcc<-}m~XAciH|GQhF=3D&kPhvvZ~OCm&t&7wb>=3Df0H(>GXK!+zpsB^hP=3DzMoWD2!
> zHeP)F8(L-l51);qXTtp77EbnU$h#bWoc|ZkKfKEPr!Mo{1(UG@Gn2pr3Jrk&livXD
> KpmHz(kO2TCINj?2
>=20
> --=20
> 2.22.0
>=20
