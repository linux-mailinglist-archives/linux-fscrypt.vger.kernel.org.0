Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7F97BCC84
	for <lists+linux-fscrypt@lfdr.de>; Sun,  8 Oct 2023 08:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344410AbjJHGMX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-fscrypt@lfdr.de>); Sun, 8 Oct 2023 02:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344392AbjJHGMW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 8 Oct 2023 02:12:22 -0400
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1012C5;
        Sat,  7 Oct 2023 23:12:17 -0700 (PDT)
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-53406799540so6298165a12.1;
        Sat, 07 Oct 2023 23:12:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696745536; x=1697350336;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VS3M1zY3oEc2+Cf5o6I+6wWg9vJPLY1QjqTlbrKjd2c=;
        b=IF4UJ/kt6S9uGNv3Y5nlDAQVB4i6ItlWuZWnx08+0aanZ0ZreVnt9MTg00Mi4Ed7XO
         jD9eHcEx/daNnpRiiUPLGSui3eiXy4OWWL6E0D3pUApegko/9l3U+Gdrx5B4MOKgUl/V
         YFR66Uh+Q00RI79h9JSWNc7icnhkmBuqzIVX+iB/Qg51ma5fgXYmSu7Prtaeu3/xk1rW
         nKWo7r576KSjJ2dwdtrNkL7y3rQTs5QsETu4esZx9LqvXrNF4wmNm3mgvod0rSfus89E
         2YWEm3A/m7DS/X2IrXWa1X5fqDEG4tegdkT5ubNJXWJy1hJytdqbQ8RB623nHI5kYn4w
         HaSw==
X-Gm-Message-State: AOJu0Yx3H8xyXp3cR5fEouyIiXPxoXvnJ635mnDvd7XqeM6zFsxvTgHW
        Ul/hCo0pOiqLdJc1Kax9muqWyblKz7nIJw==
X-Google-Smtp-Source: AGHT+IEfElHLXUThcvxXNBzMreMbR5EEuybwWl9yNCXknVnIrF5RI9Foefz7ImMI2PLn+mj/GMhySQ==
X-Received: by 2002:a05:6402:690:b0:533:6379:afaa with SMTP id f16-20020a056402069000b005336379afaamr11109867edy.20.1696745535346;
        Sat, 07 Oct 2023 23:12:15 -0700 (PDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id v10-20020aa7cd4a000000b0052889d090bfsm4712942edw.79.2023.10.07.23.12.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Oct 2023 23:12:14 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-53406799540so6298134a12.1;
        Sat, 07 Oct 2023 23:12:14 -0700 (PDT)
X-Received: by 2002:aa7:d1d8:0:b0:523:4a4e:3b57 with SMTP id
 g24-20020aa7d1d8000000b005234a4e3b57mr10477306edp.13.1696745533361; Sat, 07
 Oct 2023 23:12:13 -0700 (PDT)
MIME-Version: 1.0
References: <20231005025757.33521-1-ebiggers@kernel.org>
In-Reply-To: <20231005025757.33521-1-ebiggers@kernel.org>
From:   Neal Gompa <neal@gompa.dev>
Date:   Sun, 8 Oct 2023 02:11:36 -0400
X-Gmail-Original-Message-ID: <CAEg-Je9giOLBVwuXAQ+F6do7sTBcCpP_ARbGA6TowTT+6GBc4g@mail.gmail.com>
Message-ID: <CAEg-Je9giOLBVwuXAQ+F6do7sTBcCpP_ARbGA6TowTT+6GBc4g@mail.gmail.com>
Subject: Re: [PATCH] fscrypt: rename fscrypt_info => fscrypt_inode_info
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Oct 5, 2023 at 11:35 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Josef Bacik <josef@toxicpanda.com>
>
> We are going to track per-extent information, so it'll be necessary to
> distinguish between inode infos and extent infos.  Rename fscrypt_info
> to fscrypt_inode_info, adjusting any lines that now exceed 80
> characters.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ebiggers: renamed fscrypt_get_info(), adjusted two comments, and fixed
>  some lines over 80 characters]
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>
> Applies to commit 5b11888471806edf699316d4dcb9b426caebbef2 from
> https://git.kernel.org/pub/scm/fs/fscrypt/linux.git branch "for-next"
>
>  fs/crypto/bio.c             |  2 +-
>  fs/crypto/crypto.c          | 21 +++++++++---------
>  fs/crypto/fname.c           |  6 ++---
>  fs/crypto/fscrypt_private.h | 42 ++++++++++++++++++-----------------
>  fs/crypto/hooks.c           |  2 +-
>  fs/crypto/inline_crypt.c    | 13 ++++++-----
>  fs/crypto/keyring.c         |  4 ++--
>  fs/crypto/keysetup.c        | 44 +++++++++++++++++++------------------
>  fs/crypto/keysetup_v1.c     | 15 ++++++++-----
>  fs/crypto/policy.c          | 10 ++++-----
>  include/linux/fs.h          |  4 ++--
>  include/linux/fscrypt.h     | 10 +++++----
>  12 files changed, 92 insertions(+), 81 deletions(-)
>
> diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
> index c8cf77065272e..0ad8c30b8fa50 100644
> --- a/fs/crypto/bio.c
> +++ b/fs/crypto/bio.c
> @@ -104,21 +104,21 @@ static int fscrypt_zeroout_range_inline_crypt(const struct inode *inode,
>   * filesystem only uses a single block device, ->s_bdev.
>   *
>   * Note that since each block uses a different IV, this involves writing a
>   * different ciphertext to each block; we can't simply reuse the same one.
>   *
>   * Return: 0 on success; -errno on failure.
>   */
>  int fscrypt_zeroout_range(const struct inode *inode, pgoff_t lblk,
>                           sector_t pblk, unsigned int len)
>  {
> -       const struct fscrypt_info *ci = inode->i_crypt_info;
> +       const struct fscrypt_inode_info *ci = inode->i_crypt_info;
>         const unsigned int du_bits = ci->ci_data_unit_bits;
>         const unsigned int du_size = 1U << du_bits;
>         const unsigned int du_per_page_bits = PAGE_SHIFT - du_bits;
>         const unsigned int du_per_page = 1U << du_per_page_bits;
>         u64 du_index = (u64)lblk << (inode->i_blkbits - du_bits);
>         u64 du_remaining = (u64)len << (inode->i_blkbits - du_bits);
>         sector_t sector = pblk << (inode->i_blkbits - SECTOR_SHIFT);
>         struct page *pages[16]; /* write up to 16 pages at a time */
>         unsigned int nr_pages;
>         unsigned int i;
> diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> index 85e2f66dd663f..328470d40dec4 100644
> --- a/fs/crypto/crypto.c
> +++ b/fs/crypto/crypto.c
> @@ -32,21 +32,21 @@ static unsigned int num_prealloc_crypto_pages = 32;
>
>  module_param(num_prealloc_crypto_pages, uint, 0444);
>  MODULE_PARM_DESC(num_prealloc_crypto_pages,
>                 "Number of crypto pages to preallocate");
>
>  static mempool_t *fscrypt_bounce_page_pool = NULL;
>
>  static struct workqueue_struct *fscrypt_read_workqueue;
>  static DEFINE_MUTEX(fscrypt_init_mutex);
>
> -struct kmem_cache *fscrypt_info_cachep;
> +struct kmem_cache *fscrypt_inode_info_cachep;
>
>  void fscrypt_enqueue_decrypt_work(struct work_struct *work)
>  {
>         queue_work(fscrypt_read_workqueue, work);
>  }
>  EXPORT_SYMBOL(fscrypt_enqueue_decrypt_work);
>
>  struct page *fscrypt_alloc_bounce_page(gfp_t gfp_flags)
>  {
>         if (WARN_ON_ONCE(!fscrypt_bounce_page_pool)) {
> @@ -78,41 +78,41 @@ EXPORT_SYMBOL(fscrypt_free_bounce_page);
>
>  /*
>   * Generate the IV for the given data unit index within the given file.
>   * For filenames encryption, index == 0.
>   *
>   * Keep this in sync with fscrypt_limit_io_blocks().  fscrypt_limit_io_blocks()
>   * needs to know about any IV generation methods where the low bits of IV don't
>   * simply contain the data unit index (e.g., IV_INO_LBLK_32).
>   */
>  void fscrypt_generate_iv(union fscrypt_iv *iv, u64 index,
> -                        const struct fscrypt_info *ci)
> +                        const struct fscrypt_inode_info *ci)
>  {
>         u8 flags = fscrypt_policy_flags(&ci->ci_policy);
>
>         memset(iv, 0, ci->ci_mode->ivsize);
>
>         if (flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64) {
>                 WARN_ON_ONCE(index > U32_MAX);
>                 WARN_ON_ONCE(ci->ci_inode->i_ino > U32_MAX);
>                 index |= (u64)ci->ci_inode->i_ino << 32;
>         } else if (flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) {
>                 WARN_ON_ONCE(index > U32_MAX);
>                 index = (u32)(ci->ci_hashed_ino + index);
>         } else if (flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY) {
>                 memcpy(iv->nonce, ci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE);
>         }
>         iv->index = cpu_to_le64(index);
>  }
>
>  /* Encrypt or decrypt a single "data unit" of file contents. */
> -int fscrypt_crypt_data_unit(const struct fscrypt_info *ci,
> +int fscrypt_crypt_data_unit(const struct fscrypt_inode_info *ci,
>                             fscrypt_direction_t rw, u64 index,
>                             struct page *src_page, struct page *dest_page,
>                             unsigned int len, unsigned int offs,
>                             gfp_t gfp_flags)
>  {
>         union fscrypt_iv iv;
>         struct skcipher_request *req = NULL;
>         DECLARE_CRYPTO_WAIT(wait);
>         struct scatterlist dst, src;
>         struct crypto_skcipher *tfm = ci->ci_enc_key.tfm;
> @@ -177,21 +177,21 @@ int fscrypt_crypt_data_unit(const struct fscrypt_info *ci,
>   *
>   * Return: the new encrypted bounce page on success; an ERR_PTR() on failure
>   */
>  struct page *fscrypt_encrypt_pagecache_blocks(struct page *page,
>                                               unsigned int len,
>                                               unsigned int offs,
>                                               gfp_t gfp_flags)
>
>  {
>         const struct inode *inode = page->mapping->host;
> -       const struct fscrypt_info *ci = inode->i_crypt_info;
> +       const struct fscrypt_inode_info *ci = inode->i_crypt_info;
>         const unsigned int du_bits = ci->ci_data_unit_bits;
>         const unsigned int du_size = 1U << du_bits;
>         struct page *ciphertext_page;
>         u64 index = ((u64)page->index << (PAGE_SHIFT - du_bits)) +
>                     (offs >> du_bits);
>         unsigned int i;
>         int err;
>
>         if (WARN_ON_ONCE(!PageLocked(page)))
>                 return ERR_PTR(-EINVAL);
> @@ -260,21 +260,21 @@ EXPORT_SYMBOL(fscrypt_encrypt_block_inplace);
>   * The length and offset of the data must be aligned to the file's crypto data
>   * unit size.  Alignment to the filesystem block size fulfills this requirement,
>   * as the filesystem block size is always a multiple of the data unit size.
>   *
>   * Return: 0 on success; -errno on failure
>   */
>  int fscrypt_decrypt_pagecache_blocks(struct folio *folio, size_t len,
>                                      size_t offs)
>  {
>         const struct inode *inode = folio->mapping->host;
> -       const struct fscrypt_info *ci = inode->i_crypt_info;
> +       const struct fscrypt_inode_info *ci = inode->i_crypt_info;
>         const unsigned int du_bits = ci->ci_data_unit_bits;
>         const unsigned int du_size = 1U << du_bits;
>         u64 index = ((u64)folio->index << (PAGE_SHIFT - du_bits)) +
>                     (offs >> du_bits);
>         size_t i;
>         int err;
>
>         if (WARN_ON_ONCE(!folio_test_locked(folio)))
>                 return -EINVAL;
>
> @@ -402,28 +402,29 @@ static int __init fscrypt_init(void)
>          *
>          * Also use a high-priority workqueue to prioritize decryption work,
>          * which blocks reads from completing, over regular application tasks.
>          */
>         fscrypt_read_workqueue = alloc_workqueue("fscrypt_read_queue",
>                                                  WQ_UNBOUND | WQ_HIGHPRI,
>                                                  num_online_cpus());
>         if (!fscrypt_read_workqueue)
>                 goto fail;
>
> -       fscrypt_info_cachep = KMEM_CACHE(fscrypt_info, SLAB_RECLAIM_ACCOUNT);
> -       if (!fscrypt_info_cachep)
> +       fscrypt_inode_info_cachep = KMEM_CACHE(fscrypt_inode_info,
> +                                              SLAB_RECLAIM_ACCOUNT);
> +       if (!fscrypt_inode_info_cachep)
>                 goto fail_free_queue;
>
>         err = fscrypt_init_keyring();
>         if (err)
> -               goto fail_free_info;
> +               goto fail_free_inode_info;
>
>         return 0;
>
> -fail_free_info:
> -       kmem_cache_destroy(fscrypt_info_cachep);
> +fail_free_inode_info:
> +       kmem_cache_destroy(fscrypt_inode_info_cachep);
>  fail_free_queue:
>         destroy_workqueue(fscrypt_read_workqueue);
>  fail:
>         return err;
>  }
>  late_initcall(fscrypt_init)
> diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
> index 6eae3f12ad503..7b3fc189593a5 100644
> --- a/fs/crypto/fname.c
> +++ b/fs/crypto/fname.c
> @@ -93,21 +93,21 @@ static inline bool fscrypt_is_dot_dotdot(const struct qstr *str)
>   * @olen: size of the encrypted filename.  It must be at least @iname->len.
>   *       Any extra space is filled with NUL padding before encryption.
>   *
>   * Return: 0 on success, -errno on failure
>   */
>  int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
>                           u8 *out, unsigned int olen)
>  {
>         struct skcipher_request *req = NULL;
>         DECLARE_CRYPTO_WAIT(wait);
> -       const struct fscrypt_info *ci = inode->i_crypt_info;
> +       const struct fscrypt_inode_info *ci = inode->i_crypt_info;
>         struct crypto_skcipher *tfm = ci->ci_enc_key.tfm;
>         union fscrypt_iv iv;
>         struct scatterlist sg;
>         int res;
>
>         /*
>          * Copy the filename to the output buffer for encrypting in-place and
>          * pad it with the needed number of NUL bytes.
>          */
>         if (WARN_ON_ONCE(olen < iname->len))
> @@ -150,21 +150,21 @@ EXPORT_SYMBOL_GPL(fscrypt_fname_encrypt);
>   *
>   * Return: 0 on success, -errno on failure
>   */
>  static int fname_decrypt(const struct inode *inode,
>                          const struct fscrypt_str *iname,
>                          struct fscrypt_str *oname)
>  {
>         struct skcipher_request *req = NULL;
>         DECLARE_CRYPTO_WAIT(wait);
>         struct scatterlist src_sg, dst_sg;
> -       const struct fscrypt_info *ci = inode->i_crypt_info;
> +       const struct fscrypt_inode_info *ci = inode->i_crypt_info;
>         struct crypto_skcipher *tfm = ci->ci_enc_key.tfm;
>         union fscrypt_iv iv;
>         int res;
>
>         /* Allocate request */
>         req = skcipher_request_alloc(tfm, GFP_NOFS);
>         if (!req)
>                 return -ENOMEM;
>         skcipher_request_set_callback(req,
>                 CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
> @@ -561,21 +561,21 @@ EXPORT_SYMBOL_GPL(fscrypt_match_name);
>   * @name: the filename to calculate the SipHash of
>   *
>   * Given a plaintext filename @name and a directory @dir which uses SipHash as
>   * its dirhash method and has had its fscrypt key set up, this function
>   * calculates the SipHash of that name using the directory's secret dirhash key.
>   *
>   * Return: the SipHash of @name using the hash key of @dir
>   */
>  u64 fscrypt_fname_siphash(const struct inode *dir, const struct qstr *name)
>  {
> -       const struct fscrypt_info *ci = dir->i_crypt_info;
> +       const struct fscrypt_inode_info *ci = dir->i_crypt_info;
>
>         WARN_ON_ONCE(!ci->ci_dirhash_key_initialized);
>
>         return siphash(name->name, name->len, &ci->ci_dirhash_key);
>  }
>  EXPORT_SYMBOL_GPL(fscrypt_fname_siphash);
>
>  /*
>   * Validate dentries in encrypted directories to make sure we aren't potentially
>   * caching stale dentries after a key has been added.
> diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
> index 9c5e83baa3f12..2fb4ba435d27d 100644
> --- a/fs/crypto/fscrypt_private.h
> +++ b/fs/crypto/fscrypt_private.h
> @@ -203,32 +203,32 @@ struct fscrypt_symlink_data {
>   * Normally only one of the fields will be non-NULL.
>   */
>  struct fscrypt_prepared_key {
>         struct crypto_skcipher *tfm;
>  #ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
>         struct blk_crypto_key *blk_key;
>  #endif
>  };
>
>  /*
> - * fscrypt_info - the "encryption key" for an inode
> + * fscrypt_inode_info - the "encryption key" for an inode
>   *
>   * When an encrypted file's key is made available, an instance of this struct is
>   * allocated and stored in ->i_crypt_info.  Once created, it remains until the
>   * inode is evicted.
>   */
> -struct fscrypt_info {
> +struct fscrypt_inode_info {
>
>         /* The key in a form prepared for actual encryption/decryption */
>         struct fscrypt_prepared_key ci_enc_key;
>
> -       /* True if ci_enc_key should be freed when this fscrypt_info is freed */
> +       /* True if ci_enc_key should be freed when this struct is freed */
>         bool ci_owns_key;
>
>  #ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
>         /*
>          * True if this inode will use inline encryption (blk-crypto) instead of
>          * the traditional filesystem-layer encryption.
>          */
>         bool ci_inlinecrypt;
>  #endif
>
> @@ -287,23 +287,23 @@ struct fscrypt_info {
>         /* Hashed inode number.  Only set for IV_INO_LBLK_32 */
>         u32 ci_hashed_ino;
>  };
>
>  typedef enum {
>         FS_DECRYPT = 0,
>         FS_ENCRYPT,
>  } fscrypt_direction_t;
>
>  /* crypto.c */
> -extern struct kmem_cache *fscrypt_info_cachep;
> +extern struct kmem_cache *fscrypt_inode_info_cachep;
>  int fscrypt_initialize(struct super_block *sb);
> -int fscrypt_crypt_data_unit(const struct fscrypt_info *ci,
> +int fscrypt_crypt_data_unit(const struct fscrypt_inode_info *ci,
>                             fscrypt_direction_t rw, u64 index,
>                             struct page *src_page, struct page *dest_page,
>                             unsigned int len, unsigned int offs,
>                             gfp_t gfp_flags);
>  struct page *fscrypt_alloc_bounce_page(gfp_t gfp_flags);
>
>  void __printf(3, 4) __cold
>  fscrypt_msg(const struct inode *inode, const char *level, const char *fmt, ...);
>
>  #define fscrypt_warn(inode, fmt, ...)          \
> @@ -319,21 +319,21 @@ union fscrypt_iv {
>                 __le64 index;
>
>                 /* per-file nonce; only set in DIRECT_KEY mode */
>                 u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
>         };
>         u8 raw[FSCRYPT_MAX_IV_SIZE];
>         __le64 dun[FSCRYPT_MAX_IV_SIZE / sizeof(__le64)];
>  };
>
>  void fscrypt_generate_iv(union fscrypt_iv *iv, u64 index,
> -                        const struct fscrypt_info *ci);
> +                        const struct fscrypt_inode_info *ci);
>
>  /*
>   * Return the number of bits used by the maximum file data unit index that is
>   * possible on the given filesystem, using the given log2 data unit size.
>   */
>  static inline int
>  fscrypt_max_file_dun_bits(const struct super_block *sb, int du_bits)
>  {
>         return fls64(sb->s_maxbytes - 1) - du_bits;
>  }
> @@ -367,87 +367,87 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
>  #define HKDF_CONTEXT_INODE_HASH_KEY    7 /* info=<empty>               */
>
>  int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
>                         const u8 *info, unsigned int infolen,
>                         u8 *okm, unsigned int okmlen);
>
>  void fscrypt_destroy_hkdf(struct fscrypt_hkdf *hkdf);
>
>  /* inline_crypt.c */
>  #ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
> -int fscrypt_select_encryption_impl(struct fscrypt_info *ci);
> +int fscrypt_select_encryption_impl(struct fscrypt_inode_info *ci);
>
>  static inline bool
> -fscrypt_using_inline_encryption(const struct fscrypt_info *ci)
> +fscrypt_using_inline_encryption(const struct fscrypt_inode_info *ci)
>  {
>         return ci->ci_inlinecrypt;
>  }
>
>  int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
>                                      const u8 *raw_key,
> -                                    const struct fscrypt_info *ci);
> +                                    const struct fscrypt_inode_info *ci);
>
>  void fscrypt_destroy_inline_crypt_key(struct super_block *sb,
>                                       struct fscrypt_prepared_key *prep_key);
>
>  /*
>   * Check whether the crypto transform or blk-crypto key has been allocated in
>   * @prep_key, depending on which encryption implementation the file will use.
>   */
>  static inline bool
>  fscrypt_is_key_prepared(struct fscrypt_prepared_key *prep_key,
> -                       const struct fscrypt_info *ci)
> +                       const struct fscrypt_inode_info *ci)
>  {
>         /*
>          * The two smp_load_acquire()'s here pair with the smp_store_release()'s
>          * in fscrypt_prepare_inline_crypt_key() and fscrypt_prepare_key().
>          * I.e., in some cases (namely, if this prep_key is a per-mode
>          * encryption key) another task can publish blk_key or tfm concurrently,
>          * executing a RELEASE barrier.  We need to use smp_load_acquire() here
>          * to safely ACQUIRE the memory the other task published.
>          */
>         if (fscrypt_using_inline_encryption(ci))
>                 return smp_load_acquire(&prep_key->blk_key) != NULL;
>         return smp_load_acquire(&prep_key->tfm) != NULL;
>  }
>
>  #else /* CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
>
> -static inline int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
> +static inline int fscrypt_select_encryption_impl(struct fscrypt_inode_info *ci)
>  {
>         return 0;
>  }
>
>  static inline bool
> -fscrypt_using_inline_encryption(const struct fscrypt_info *ci)
> +fscrypt_using_inline_encryption(const struct fscrypt_inode_info *ci)
>  {
>         return false;
>  }
>
>  static inline int
>  fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
>                                  const u8 *raw_key,
> -                                const struct fscrypt_info *ci)
> +                                const struct fscrypt_inode_info *ci)
>  {
>         WARN_ON_ONCE(1);
>         return -EOPNOTSUPP;
>  }
>
>  static inline void
>  fscrypt_destroy_inline_crypt_key(struct super_block *sb,
>                                  struct fscrypt_prepared_key *prep_key)
>  {
>  }
>
>  static inline bool
>  fscrypt_is_key_prepared(struct fscrypt_prepared_key *prep_key,
> -                       const struct fscrypt_info *ci)
> +                       const struct fscrypt_inode_info *ci)
>  {
>         return smp_load_acquire(&prep_key->tfm) != NULL;
>  }
>  #endif /* !CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
>
>  /* keyring.c */
>
>  /*
>   * fscrypt_master_key_secret - secret key material of an in-use master key
>   */
> @@ -633,31 +633,32 @@ struct fscrypt_mode {
>         int ivsize;             /* IV size in bytes */
>         int logged_cryptoapi_impl;
>         int logged_blk_crypto_native;
>         int logged_blk_crypto_fallback;
>         enum blk_crypto_mode_num blk_crypto_mode;
>  };
>
>  extern struct fscrypt_mode fscrypt_modes[];
>
>  int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
> -                       const u8 *raw_key, const struct fscrypt_info *ci);
> +                       const u8 *raw_key, const struct fscrypt_inode_info *ci);
>
>  void fscrypt_destroy_prepared_key(struct super_block *sb,
>                                   struct fscrypt_prepared_key *prep_key);
>
> -int fscrypt_set_per_file_enc_key(struct fscrypt_info *ci, const u8 *raw_key);
> +int fscrypt_set_per_file_enc_key(struct fscrypt_inode_info *ci,
> +                                const u8 *raw_key);
>
> -int fscrypt_derive_dirhash_key(struct fscrypt_info *ci,
> +int fscrypt_derive_dirhash_key(struct fscrypt_inode_info *ci,
>                                const struct fscrypt_master_key *mk);
>
> -void fscrypt_hash_inode_number(struct fscrypt_info *ci,
> +void fscrypt_hash_inode_number(struct fscrypt_inode_info *ci,
>                                const struct fscrypt_master_key *mk);
>
>  int fscrypt_get_encryption_info(struct inode *inode, bool allow_unsupported);
>
>  /**
>   * fscrypt_require_key() - require an inode's encryption key
>   * @inode: the inode we need the key for
>   *
>   * If the inode is encrypted, set up its encryption key if not already done.
>   * Then require that the key be present and return -ENOKEY otherwise.
> @@ -678,24 +679,25 @@ static inline int fscrypt_require_key(struct inode *inode)
>                 if (!fscrypt_has_encryption_key(inode))
>                         return -ENOKEY;
>         }
>         return 0;
>  }
>
>  /* keysetup_v1.c */
>
>  void fscrypt_put_direct_key(struct fscrypt_direct_key *dk);
>
> -int fscrypt_setup_v1_file_key(struct fscrypt_info *ci,
> +int fscrypt_setup_v1_file_key(struct fscrypt_inode_info *ci,
>                               const u8 *raw_master_key);
>
> -int fscrypt_setup_v1_file_key_via_subscribed_keyrings(struct fscrypt_info *ci);
> +int fscrypt_setup_v1_file_key_via_subscribed_keyrings(
> +                               struct fscrypt_inode_info *ci);
>
>  /* policy.c */
>
>  bool fscrypt_policies_equal(const union fscrypt_policy *policy1,
>                             const union fscrypt_policy *policy2);
>  int fscrypt_policy_to_key_spec(const union fscrypt_policy *policy,
>                                struct fscrypt_key_specifier *key_spec);
>  const union fscrypt_policy *fscrypt_get_dummy_policy(struct super_block *sb);
>  bool fscrypt_supported_policy(const union fscrypt_policy *policy_u,
>                               const struct inode *inode);
> diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
> index 6238dbcadcad8..85d2975b69b78 100644
> --- a/fs/crypto/hooks.c
> +++ b/fs/crypto/hooks.c
> @@ -162,21 +162,21 @@ EXPORT_SYMBOL_GPL(__fscrypt_prepare_setattr);
>   * @flags: the new flags
>   *
>   * The caller should be holding i_rwsem for write.
>   *
>   * Return: 0 on success; -errno if the flags change isn't allowed or if
>   *        another error occurs.
>   */
>  int fscrypt_prepare_setflags(struct inode *inode,
>                              unsigned int oldflags, unsigned int flags)
>  {
> -       struct fscrypt_info *ci;
> +       struct fscrypt_inode_info *ci;
>         struct fscrypt_master_key *mk;
>         int err;
>
>         /*
>          * When the CASEFOLD flag is set on an encrypted directory, we must
>          * derive the secret key needed for the dirhash.  This is only possible
>          * if the directory uses a v2 encryption policy.
>          */
>         if (IS_ENCRYPTED(inode) && (flags & ~oldflags & FS_CASEFOLD_FL)) {
>                 err = fscrypt_require_key(inode);
> diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
> index 8c6d37d6225a8..b4002aea7cdb9 100644
> --- a/fs/crypto/inline_crypt.c
> +++ b/fs/crypto/inline_crypt.c
> @@ -32,21 +32,21 @@ static struct block_device **fscrypt_get_devices(struct super_block *sb,
>                         return devs;
>         }
>         devs = kmalloc(sizeof(*devs), GFP_KERNEL);
>         if (!devs)
>                 return ERR_PTR(-ENOMEM);
>         devs[0] = sb->s_bdev;
>         *num_devs = 1;
>         return devs;
>  }
>
> -static unsigned int fscrypt_get_dun_bytes(const struct fscrypt_info *ci)
> +static unsigned int fscrypt_get_dun_bytes(const struct fscrypt_inode_info *ci)
>  {
>         const struct super_block *sb = ci->ci_inode->i_sb;
>         unsigned int flags = fscrypt_policy_flags(&ci->ci_policy);
>         int dun_bits;
>
>         if (flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY)
>                 return offsetofend(union fscrypt_iv, nonce);
>
>         if (flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64)
>                 return sizeof(__le64);
> @@ -82,21 +82,21 @@ static void fscrypt_log_blk_crypto_impl(struct fscrypt_mode *mode,
>                                 pr_info("fscrypt: %s using blk-crypto (native)\n",
>                                         mode->friendly_name);
>                 } else if (!xchg(&mode->logged_blk_crypto_fallback, 1)) {
>                         pr_info("fscrypt: %s using blk-crypto-fallback\n",
>                                 mode->friendly_name);
>                 }
>         }
>  }
>
>  /* Enable inline encryption for this file if supported. */
> -int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
> +int fscrypt_select_encryption_impl(struct fscrypt_inode_info *ci)
>  {
>         const struct inode *inode = ci->ci_inode;
>         struct super_block *sb = inode->i_sb;
>         struct blk_crypto_config crypto_cfg;
>         struct block_device **devs;
>         unsigned int num_devs;
>         unsigned int i;
>
>         /* The file must need contents encryption, not filenames encryption */
>         if (!S_ISREG(inode->i_mode))
> @@ -144,21 +144,21 @@ int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
>
>         ci->ci_inlinecrypt = true;
>  out_free_devs:
>         kfree(devs);
>
>         return 0;
>  }
>
>  int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
>                                      const u8 *raw_key,
> -                                    const struct fscrypt_info *ci)
> +                                    const struct fscrypt_inode_info *ci)
>  {
>         const struct inode *inode = ci->ci_inode;
>         struct super_block *sb = inode->i_sb;
>         enum blk_crypto_mode_num crypto_mode = ci->ci_mode->blk_crypto_mode;
>         struct blk_crypto_key *blk_key;
>         struct block_device **devs;
>         unsigned int num_devs;
>         unsigned int i;
>         int err;
>
> @@ -225,21 +225,22 @@ void fscrypt_destroy_inline_crypt_key(struct super_block *sb,
>         }
>         kfree_sensitive(blk_key);
>  }
>
>  bool __fscrypt_inode_uses_inline_crypto(const struct inode *inode)
>  {
>         return inode->i_crypt_info->ci_inlinecrypt;
>  }
>  EXPORT_SYMBOL_GPL(__fscrypt_inode_uses_inline_crypto);
>
> -static void fscrypt_generate_dun(const struct fscrypt_info *ci, u64 lblk_num,
> +static void fscrypt_generate_dun(const struct fscrypt_inode_info *ci,
> +                                u64 lblk_num,
>                                  u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE])
>  {
>         u64 index = lblk_num << ci->ci_data_units_per_block_bits;
>         union fscrypt_iv iv;
>         int i;
>
>         fscrypt_generate_iv(&iv, index, ci);
>
>         BUILD_BUG_ON(FSCRYPT_MAX_IV_SIZE > BLK_CRYPTO_MAX_IV_SIZE);
>         memset(dun, 0, BLK_CRYPTO_MAX_IV_SIZE);
> @@ -259,21 +260,21 @@ static void fscrypt_generate_dun(const struct fscrypt_info *ci, u64 lblk_num,
>   * encryption, then assign the appropriate encryption context to the bio.
>   *
>   * Normally the bio should be newly allocated (i.e. no pages added yet), as
>   * otherwise fscrypt_mergeable_bio() won't work as intended.
>   *
>   * The encryption context will be freed automatically when the bio is freed.
>   */
>  void fscrypt_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
>                                u64 first_lblk, gfp_t gfp_mask)
>  {
> -       const struct fscrypt_info *ci;
> +       const struct fscrypt_inode_info *ci;
>         u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
>
>         if (!fscrypt_inode_uses_inline_crypto(inode))
>                 return;
>         ci = inode->i_crypt_info;
>
>         fscrypt_generate_dun(ci, first_lblk, dun);
>         bio_crypt_set_ctx(bio, ci->ci_enc_key.blk_key, dun, gfp_mask);
>  }
>  EXPORT_SYMBOL_GPL(fscrypt_set_bio_crypt_ctx);
> @@ -450,21 +451,21 @@ EXPORT_SYMBOL_GPL(fscrypt_dio_supported);
>   * In rare cases, fscrypt can be using an IV generation method that allows the
>   * DUN to wrap around within logically contiguous blocks, and that wraparound
>   * will occur.  If this happens, a value less than @nr_blocks will be returned
>   * so that the wraparound doesn't occur in the middle of a bio, which would
>   * cause encryption/decryption to produce wrong results.
>   *
>   * Return: the actual number of blocks that can be submitted
>   */
>  u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks)
>  {
> -       const struct fscrypt_info *ci;
> +       const struct fscrypt_inode_info *ci;
>         u32 dun;
>
>         if (!fscrypt_inode_uses_inline_crypto(inode))
>                 return nr_blocks;
>
>         if (nr_blocks <= 1)
>                 return nr_blocks;
>
>         ci = inode->i_crypt_info;
>         if (!(fscrypt_policy_flags(&ci->ci_policy) &
> diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
> index 7cbb1fd872acc..a51fa6a33de10 100644
> --- a/fs/crypto/keyring.c
> +++ b/fs/crypto/keyring.c
> @@ -860,21 +860,21 @@ static void shrink_dcache_inode(struct inode *inode)
>                 if (dentry) {
>                         shrink_dcache_parent(dentry);
>                         dput(dentry);
>                 }
>         }
>         d_prune_aliases(inode);
>  }
>
>  static void evict_dentries_for_decrypted_inodes(struct fscrypt_master_key *mk)
>  {
> -       struct fscrypt_info *ci;
> +       struct fscrypt_inode_info *ci;
>         struct inode *inode;
>         struct inode *toput_inode = NULL;
>
>         spin_lock(&mk->mk_decrypted_inodes_lock);
>
>         list_for_each_entry(ci, &mk->mk_decrypted_inodes, ci_master_key_link) {
>                 inode = ci->ci_inode;
>                 spin_lock(&inode->i_lock);
>                 if (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) {
>                         spin_unlock(&inode->i_lock);
> @@ -910,21 +910,21 @@ static int check_for_busy_inodes(struct super_block *sb,
>
>         if (busy_count == 0) {
>                 spin_unlock(&mk->mk_decrypted_inodes_lock);
>                 return 0;
>         }
>
>         {
>                 /* select an example file to show for debugging purposes */
>                 struct inode *inode =
>                         list_first_entry(&mk->mk_decrypted_inodes,
> -                                        struct fscrypt_info,
> +                                        struct fscrypt_inode_info,
>                                          ci_master_key_link)->ci_inode;
>                 ino = inode->i_ino;
>         }
>         spin_unlock(&mk->mk_decrypted_inodes_lock);
>
>         /* If the inode is currently being created, ino may still be 0. */
>         if (ino)
>                 snprintf(ino_str, sizeof(ino_str), ", including ino %lu", ino);
>
>         fscrypt_warn(NULL,
> diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
> index 608599f8aa574..094d1b7a1ae61 100644
> --- a/fs/crypto/keysetup.c
> +++ b/fs/crypto/keysetup.c
> @@ -141,21 +141,21 @@ fscrypt_allocate_skcipher(struct fscrypt_mode *mode, const u8 *raw_key,
>         return ERR_PTR(err);
>  }
>
>  /*
>   * Prepare the crypto transform object or blk-crypto key in @prep_key, given the
>   * raw key, encryption mode (@ci->ci_mode), flag indicating which encryption
>   * implementation (fs-layer or blk-crypto) will be used (@ci->ci_inlinecrypt),
>   * and IV generation method (@ci->ci_policy.flags).
>   */
>  int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
> -                       const u8 *raw_key, const struct fscrypt_info *ci)
> +                       const u8 *raw_key, const struct fscrypt_inode_info *ci)
>  {
>         struct crypto_skcipher *tfm;
>
>         if (fscrypt_using_inline_encryption(ci))
>                 return fscrypt_prepare_inline_crypt_key(prep_key, raw_key, ci);
>
>         tfm = fscrypt_allocate_skcipher(ci->ci_mode, raw_key, ci->ci_inode);
>         if (IS_ERR(tfm))
>                 return PTR_ERR(tfm);
>         /*
> @@ -171,27 +171,28 @@ int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
>  /* Destroy a crypto transform object and/or blk-crypto key. */
>  void fscrypt_destroy_prepared_key(struct super_block *sb,
>                                   struct fscrypt_prepared_key *prep_key)
>  {
>         crypto_free_skcipher(prep_key->tfm);
>         fscrypt_destroy_inline_crypt_key(sb, prep_key);
>         memzero_explicit(prep_key, sizeof(*prep_key));
>  }
>
>  /* Given a per-file encryption key, set up the file's crypto transform object */
> -int fscrypt_set_per_file_enc_key(struct fscrypt_info *ci, const u8 *raw_key)
> +int fscrypt_set_per_file_enc_key(struct fscrypt_inode_info *ci,
> +                                const u8 *raw_key)
>  {
>         ci->ci_owns_key = true;
>         return fscrypt_prepare_key(&ci->ci_enc_key, raw_key, ci);
>  }
>
> -static int setup_per_mode_enc_key(struct fscrypt_info *ci,
> +static int setup_per_mode_enc_key(struct fscrypt_inode_info *ci,
>                                   struct fscrypt_master_key *mk,
>                                   struct fscrypt_prepared_key *keys,
>                                   u8 hkdf_context, bool include_fs_uuid)
>  {
>         const struct inode *inode = ci->ci_inode;
>         const struct super_block *sb = inode->i_sb;
>         struct fscrypt_mode *mode = ci->ci_mode;
>         const u8 mode_num = mode - fscrypt_modes;
>         struct fscrypt_prepared_key *prep_key;
>         u8 mode_key[FSCRYPT_MAX_KEY_SIZE];
> @@ -258,45 +259,45 @@ static int fscrypt_derive_siphash_key(const struct fscrypt_master_key *mk,
>         if (err)
>                 return err;
>
>         BUILD_BUG_ON(sizeof(*key) != 16);
>         BUILD_BUG_ON(ARRAY_SIZE(key->key) != 2);
>         le64_to_cpus(&key->key[0]);
>         le64_to_cpus(&key->key[1]);
>         return 0;
>  }
>
> -int fscrypt_derive_dirhash_key(struct fscrypt_info *ci,
> +int fscrypt_derive_dirhash_key(struct fscrypt_inode_info *ci,
>                                const struct fscrypt_master_key *mk)
>  {
>         int err;
>
>         err = fscrypt_derive_siphash_key(mk, HKDF_CONTEXT_DIRHASH_KEY,
>                                          ci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE,
>                                          &ci->ci_dirhash_key);
>         if (err)
>                 return err;
>         ci->ci_dirhash_key_initialized = true;
>         return 0;
>  }
>
> -void fscrypt_hash_inode_number(struct fscrypt_info *ci,
> +void fscrypt_hash_inode_number(struct fscrypt_inode_info *ci,
>                                const struct fscrypt_master_key *mk)
>  {
>         WARN_ON_ONCE(ci->ci_inode->i_ino == 0);
>         WARN_ON_ONCE(!mk->mk_ino_hash_key_initialized);
>
>         ci->ci_hashed_ino = (u32)siphash_1u64(ci->ci_inode->i_ino,
>                                               &mk->mk_ino_hash_key);
>  }
>
> -static int fscrypt_setup_iv_ino_lblk_32_key(struct fscrypt_info *ci,
> +static int fscrypt_setup_iv_ino_lblk_32_key(struct fscrypt_inode_info *ci,
>                                             struct fscrypt_master_key *mk)
>  {
>         int err;
>
>         err = setup_per_mode_enc_key(ci, mk, mk->mk_iv_ino_lblk_32_keys,
>                                      HKDF_CONTEXT_IV_INO_LBLK_32_KEY, true);
>         if (err)
>                 return err;
>
>         /* pairs with smp_store_release() below */
> @@ -322,21 +323,21 @@ static int fscrypt_setup_iv_ino_lblk_32_key(struct fscrypt_info *ci,
>
>         /*
>          * New inodes may not have an inode number assigned yet.
>          * Hashing their inode number is delayed until later.
>          */
>         if (ci->ci_inode->i_ino)
>                 fscrypt_hash_inode_number(ci, mk);
>         return 0;
>  }
>
> -static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
> +static int fscrypt_setup_v2_file_key(struct fscrypt_inode_info *ci,
>                                      struct fscrypt_master_key *mk,
>                                      bool need_dirhash_key)
>  {
>         int err;
>
>         if (ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY) {
>                 /*
>                  * DIRECT_KEY: instead of deriving per-file encryption keys, the
>                  * per-file nonce will be included in all the IVs.  But unlike
>                  * v1 policies, for v2 policies in this case we don't encrypt
> @@ -397,21 +398,21 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
>   * requirement: we require that the size of the master key be at least the
>   * maximum security strength of any algorithm whose key will be derived from it
>   * (but in practice we only need to consider @ci->ci_mode, since any other
>   * possible subkeys such as DIRHASH and INODE_HASH will never increase the
>   * required key size over @ci->ci_mode).  This allows AES-256-XTS keys to be
>   * derived from a 256-bit master key, which is cryptographically sufficient,
>   * rather than requiring a 512-bit master key which is unnecessarily long.  (We
>   * still allow 512-bit master keys if the user chooses to use them, though.)
>   */
>  static bool fscrypt_valid_master_key_size(const struct fscrypt_master_key *mk,
> -                                         const struct fscrypt_info *ci)
> +                                         const struct fscrypt_inode_info *ci)
>  {
>         unsigned int min_keysize;
>
>         if (ci->ci_policy.version == FSCRYPT_POLICY_V1)
>                 min_keysize = ci->ci_mode->keysize;
>         else
>                 min_keysize = ci->ci_mode->security_strength;
>
>         if (mk->mk_secret.size < min_keysize) {
>                 fscrypt_warn(NULL,
> @@ -423,25 +424,26 @@ static bool fscrypt_valid_master_key_size(const struct fscrypt_master_key *mk,
>                 return false;
>         }
>         return true;
>  }
>
>  /*
>   * Find the master key, then set up the inode's actual encryption key.
>   *
>   * If the master key is found in the filesystem-level keyring, then it is
>   * returned in *mk_ret with its semaphore read-locked.  This is needed to ensure
> - * that only one task links the fscrypt_info into ->mk_decrypted_inodes (as
> - * multiple tasks may race to create an fscrypt_info for the same inode), and to
> - * synchronize the master key being removed with a new inode starting to use it.
> + * that only one task links the fscrypt_inode_info into ->mk_decrypted_inodes
> + * (as multiple tasks may race to create an fscrypt_inode_info for the same
> + * inode), and to synchronize the master key being removed with a new inode
> + * starting to use it.
>   */
> -static int setup_file_encryption_key(struct fscrypt_info *ci,
> +static int setup_file_encryption_key(struct fscrypt_inode_info *ci,
>                                      bool need_dirhash_key,
>                                      struct fscrypt_master_key **mk_ret)
>  {
>         struct super_block *sb = ci->ci_inode->i_sb;
>         struct fscrypt_key_specifier mk_spec;
>         struct fscrypt_master_key *mk;
>         int err;
>
>         err = fscrypt_select_encryption_impl(ci);
>         if (err)
> @@ -512,21 +514,21 @@ static int setup_file_encryption_key(struct fscrypt_info *ci,
>
>         *mk_ret = mk;
>         return 0;
>
>  out_release_key:
>         up_read(&mk->mk_sem);
>         fscrypt_put_master_key(mk);
>         return err;
>  }
>
> -static void put_crypt_info(struct fscrypt_info *ci)
> +static void put_crypt_info(struct fscrypt_inode_info *ci)
>  {
>         struct fscrypt_master_key *mk;
>
>         if (!ci)
>                 return;
>
>         if (ci->ci_direct_key)
>                 fscrypt_put_direct_key(ci->ci_direct_key);
>         else if (ci->ci_owns_key)
>                 fscrypt_destroy_prepared_key(ci->ci_inode->i_sb,
> @@ -539,39 +541,39 @@ static void put_crypt_info(struct fscrypt_info *ci)
>                  * with the master key.  In addition, if we're removing the last
>                  * inode from a master key struct that already had its secret
>                  * removed, then complete the full removal of the struct.
>                  */
>                 spin_lock(&mk->mk_decrypted_inodes_lock);
>                 list_del(&ci->ci_master_key_link);
>                 spin_unlock(&mk->mk_decrypted_inodes_lock);
>                 fscrypt_put_master_key_activeref(ci->ci_inode->i_sb, mk);
>         }
>         memzero_explicit(ci, sizeof(*ci));
> -       kmem_cache_free(fscrypt_info_cachep, ci);
> +       kmem_cache_free(fscrypt_inode_info_cachep, ci);
>  }
>
>  static int
>  fscrypt_setup_encryption_info(struct inode *inode,
>                               const union fscrypt_policy *policy,
>                               const u8 nonce[FSCRYPT_FILE_NONCE_SIZE],
>                               bool need_dirhash_key)
>  {
> -       struct fscrypt_info *crypt_info;
> +       struct fscrypt_inode_info *crypt_info;
>         struct fscrypt_mode *mode;
>         struct fscrypt_master_key *mk = NULL;
>         int res;
>
>         res = fscrypt_initialize(inode->i_sb);
>         if (res)
>                 return res;
>
> -       crypt_info = kmem_cache_zalloc(fscrypt_info_cachep, GFP_KERNEL);
> +       crypt_info = kmem_cache_zalloc(fscrypt_inode_info_cachep, GFP_KERNEL);
>         if (!crypt_info)
>                 return -ENOMEM;
>
>         crypt_info->ci_inode = inode;
>         crypt_info->ci_policy = *policy;
>         memcpy(crypt_info->ci_nonce, nonce, FSCRYPT_FILE_NONCE_SIZE);
>
>         mode = select_encryption_mode(&crypt_info->ci_policy, inode);
>         if (IS_ERR(mode)) {
>                 res = PTR_ERR(mode);
> @@ -585,22 +587,22 @@ fscrypt_setup_encryption_info(struct inode *inode,
>         crypt_info->ci_data_units_per_block_bits =
>                 inode->i_blkbits - crypt_info->ci_data_unit_bits;
>
>         res = setup_file_encryption_key(crypt_info, need_dirhash_key, &mk);
>         if (res)
>                 goto out;
>
>         /*
>          * For existing inodes, multiple tasks may race to set ->i_crypt_info.
>          * So use cmpxchg_release().  This pairs with the smp_load_acquire() in
> -        * fscrypt_get_info().  I.e., here we publish ->i_crypt_info with a
> -        * RELEASE barrier so that other tasks can ACQUIRE it.
> +        * fscrypt_get_inode_info().  I.e., here we publish ->i_crypt_info with
> +        * a RELEASE barrier so that other tasks can ACQUIRE it.
>          */
>         if (cmpxchg_release(&inode->i_crypt_info, NULL, crypt_info) == NULL) {
>                 /*
>                  * We won the race and set ->i_crypt_info to our crypt_info.
>                  * Now link it into the master key's inode list.
>                  */
>                 if (mk) {
>                         crypt_info->ci_master_key = mk;
>                         refcount_inc(&mk->mk_active_refs);
>                         spin_lock(&mk->mk_decrypted_inodes_lock);
> @@ -733,22 +735,22 @@ int fscrypt_prepare_new_inode(struct inode *dir, struct inode *inode,
>         return fscrypt_setup_encryption_info(inode, policy, nonce,
>                                              IS_CASEFOLDED(dir) &&
>                                              S_ISDIR(inode->i_mode));
>  }
>  EXPORT_SYMBOL_GPL(fscrypt_prepare_new_inode);
>
>  /**
>   * fscrypt_put_encryption_info() - free most of an inode's fscrypt data
>   * @inode: an inode being evicted
>   *
> - * Free the inode's fscrypt_info.  Filesystems must call this when the inode is
> - * being evicted.  An RCU grace period need not have elapsed yet.
> + * Free the inode's fscrypt_inode_info.  Filesystems must call this when the
> + * inode is being evicted.  An RCU grace period need not have elapsed yet.
>   */
>  void fscrypt_put_encryption_info(struct inode *inode)
>  {
>         put_crypt_info(inode->i_crypt_info);
>         inode->i_crypt_info = NULL;
>  }
>  EXPORT_SYMBOL(fscrypt_put_encryption_info);
>
>  /**
>   * fscrypt_free_inode() - free an inode's fscrypt data requiring RCU delay
> @@ -771,21 +773,21 @@ EXPORT_SYMBOL(fscrypt_free_inode);
>   * @inode: an inode being considered for eviction
>   *
>   * Filesystems supporting fscrypt must call this from their ->drop_inode()
>   * method so that encrypted inodes are evicted as soon as they're no longer in
>   * use and their master key has been removed.
>   *
>   * Return: 1 if fscrypt wants the inode to be evicted now, otherwise 0
>   */
>  int fscrypt_drop_inode(struct inode *inode)
>  {
> -       const struct fscrypt_info *ci = fscrypt_get_info(inode);
> +       const struct fscrypt_inode_info *ci = fscrypt_get_inode_info(inode);
>
>         /*
>          * If ci is NULL, then the inode doesn't have an encryption key set up
>          * so it's irrelevant.  If ci_master_key is NULL, then the master key
>          * was provided via the legacy mechanism of the process-subscribed
>          * keyrings, so we don't know whether it's been removed or not.
>          */
>         if (!ci || !ci->ci_master_key)
>                 return 0;
>
> diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
> index 86b48a2b47d1b..a10710bc81230 100644
> --- a/fs/crypto/keysetup_v1.c
> +++ b/fs/crypto/keysetup_v1.c
> @@ -171,21 +171,22 @@ void fscrypt_put_direct_key(struct fscrypt_direct_key *dk)
>  }
>
>  /*
>   * Find/insert the given key into the fscrypt_direct_keys table.  If found, it
>   * is returned with elevated refcount, and 'to_insert' is freed if non-NULL.  If
>   * not found, 'to_insert' is inserted and returned if it's non-NULL; otherwise
>   * NULL is returned.
>   */
>  static struct fscrypt_direct_key *
>  find_or_insert_direct_key(struct fscrypt_direct_key *to_insert,
> -                         const u8 *raw_key, const struct fscrypt_info *ci)
> +                         const u8 *raw_key,
> +                         const struct fscrypt_inode_info *ci)
>  {
>         unsigned long hash_key;
>         struct fscrypt_direct_key *dk;
>
>         /*
>          * Careful: to avoid potentially leaking secret key bytes via timing
>          * information, we must key the hash table by descriptor rather than by
>          * raw key, and use crypto_memneq() when comparing raw keys.
>          */
>
> @@ -211,21 +212,21 @@ find_or_insert_direct_key(struct fscrypt_direct_key *to_insert,
>                 return dk;
>         }
>         if (to_insert)
>                 hash_add(fscrypt_direct_keys, &to_insert->dk_node, hash_key);
>         spin_unlock(&fscrypt_direct_keys_lock);
>         return to_insert;
>  }
>
>  /* Prepare to encrypt directly using the master key in the given mode */
>  static struct fscrypt_direct_key *
> -fscrypt_get_direct_key(const struct fscrypt_info *ci, const u8 *raw_key)
> +fscrypt_get_direct_key(const struct fscrypt_inode_info *ci, const u8 *raw_key)
>  {
>         struct fscrypt_direct_key *dk;
>         int err;
>
>         /* Is there already a tfm for this key? */
>         dk = find_or_insert_direct_key(NULL, raw_key, ci);
>         if (dk)
>                 return dk;
>
>         /* Nope, allocate one. */
> @@ -243,35 +244,35 @@ fscrypt_get_direct_key(const struct fscrypt_info *ci, const u8 *raw_key)
>         memcpy(dk->dk_raw, raw_key, ci->ci_mode->keysize);
>
>         return find_or_insert_direct_key(dk, raw_key, ci);
>
>  err_free_dk:
>         free_direct_key(dk);
>         return ERR_PTR(err);
>  }
>
>  /* v1 policy, DIRECT_KEY: use the master key directly */
> -static int setup_v1_file_key_direct(struct fscrypt_info *ci,
> +static int setup_v1_file_key_direct(struct fscrypt_inode_info *ci,
>                                     const u8 *raw_master_key)
>  {
>         struct fscrypt_direct_key *dk;
>
>         dk = fscrypt_get_direct_key(ci, raw_master_key);
>         if (IS_ERR(dk))
>                 return PTR_ERR(dk);
>         ci->ci_direct_key = dk;
>         ci->ci_enc_key = dk->dk_key;
>         return 0;
>  }
>
>  /* v1 policy, !DIRECT_KEY: derive the file's encryption key */
> -static int setup_v1_file_key_derived(struct fscrypt_info *ci,
> +static int setup_v1_file_key_derived(struct fscrypt_inode_info *ci,
>                                      const u8 *raw_master_key)
>  {
>         u8 *derived_key;
>         int err;
>
>         /*
>          * This cannot be a stack buffer because it will be passed to the
>          * scatterlist crypto API during derive_key_aes().
>          */
>         derived_key = kmalloc(ci->ci_mode->keysize, GFP_KERNEL);
> @@ -282,29 +283,31 @@ static int setup_v1_file_key_derived(struct fscrypt_info *ci,
>                              derived_key, ci->ci_mode->keysize);
>         if (err)
>                 goto out;
>
>         err = fscrypt_set_per_file_enc_key(ci, derived_key);
>  out:
>         kfree_sensitive(derived_key);
>         return err;
>  }
>
> -int fscrypt_setup_v1_file_key(struct fscrypt_info *ci, const u8 *raw_master_key)
> +int fscrypt_setup_v1_file_key(struct fscrypt_inode_info *ci,
> +                             const u8 *raw_master_key)
>  {
>         if (ci->ci_policy.v1.flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY)
>                 return setup_v1_file_key_direct(ci, raw_master_key);
>         else
>                 return setup_v1_file_key_derived(ci, raw_master_key);
>  }
>
> -int fscrypt_setup_v1_file_key_via_subscribed_keyrings(struct fscrypt_info *ci)
> +int
> +fscrypt_setup_v1_file_key_via_subscribed_keyrings(struct fscrypt_inode_info *ci)
>  {
>         const struct super_block *sb = ci->ci_inode->i_sb;
>         struct key *key;
>         const struct fscrypt_key *payload;
>         int err;
>
>         key = find_and_lock_process_key(FSCRYPT_KEY_DESC_PREFIX,
>                                         ci->ci_policy.v1.master_key_descriptor,
>                                         ci->ci_mode->keysize, &payload);
>         if (key == ERR_PTR(-ENOKEY) && sb->s_cop->legacy_key_prefix) {
> diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
> index 2fb3f6a1258e0..701259991277e 100644
> --- a/fs/crypto/policy.c
> +++ b/fs/crypto/policy.c
> @@ -425,25 +425,25 @@ int fscrypt_policy_from_context(union fscrypt_policy *policy_u,
>                 return 0;
>         }
>         }
>         /* unreachable */
>         return -EINVAL;
>  }
>
>  /* Retrieve an inode's encryption policy */
>  static int fscrypt_get_policy(struct inode *inode, union fscrypt_policy *policy)
>  {
> -       const struct fscrypt_info *ci;
> +       const struct fscrypt_inode_info *ci;
>         union fscrypt_context ctx;
>         int ret;
>
> -       ci = fscrypt_get_info(inode);
> +       ci = fscrypt_get_inode_info(inode);
>         if (ci) {
>                 /* key available, use the cached policy */
>                 *policy = ci->ci_policy;
>                 return 0;
>         }
>
>         if (!IS_ENCRYPTED(inode))
>                 return -ENODATA;
>
>         ret = inode->i_sb->s_cop->get_context(inode, &ctx, sizeof(ctx));
> @@ -667,21 +667,21 @@ int fscrypt_has_permitted_context(struct inode *parent, struct inode *child)
>         /* No restrictions if the parent directory is unencrypted */
>         if (!IS_ENCRYPTED(parent))
>                 return 1;
>
>         /* Encrypted directories must not contain unencrypted files */
>         if (!IS_ENCRYPTED(child))
>                 return 0;
>
>         /*
>          * Both parent and child are encrypted, so verify they use the same
> -        * encryption policy.  Compare the fscrypt_info structs if the keys are
> +        * encryption policy.  Compare the cached policies if the keys are
>          * available, otherwise retrieve and compare the fscrypt_contexts.
>          *
>          * Note that the fscrypt_context retrieval will be required frequently
>          * when accessing an encrypted directory tree without the key.
>          * Performance-wise this is not a big deal because we already don't
>          * really optimize for file access without the key (to the extent that
>          * such access is even possible), given that any attempted access
>          * already causes a fscrypt_context retrieval and keyring search.
>          *
>          * In any case, if an unexpected error occurs, fall back to "forbidden".
> @@ -737,21 +737,21 @@ const union fscrypt_policy *fscrypt_policy_to_inherit(struct inode *dir)
>   * @inode: inode from which to fetch policy and nonce
>   *
>   * Given an in-core "prepared" (via fscrypt_prepare_new_inode) inode,
>   * generate a new context and write it to ctx. ctx _must_ be at least
>   * FSCRYPT_SET_CONTEXT_MAX_SIZE bytes.
>   *
>   * Return: size of the resulting context or a negative error code.
>   */
>  int fscrypt_context_for_new_inode(void *ctx, struct inode *inode)
>  {
> -       struct fscrypt_info *ci = inode->i_crypt_info;
> +       struct fscrypt_inode_info *ci = inode->i_crypt_info;
>
>         BUILD_BUG_ON(sizeof(union fscrypt_context) !=
>                         FSCRYPT_SET_CONTEXT_MAX_SIZE);
>
>         /* fscrypt_prepare_new_inode() should have set up the key already. */
>         if (WARN_ON_ONCE(!ci))
>                 return -ENOKEY;
>
>         return fscrypt_new_context(ctx, &ci->ci_policy, ci->ci_nonce);
>  }
> @@ -762,21 +762,21 @@ EXPORT_SYMBOL_GPL(fscrypt_context_for_new_inode);
>   * @inode: a new inode
>   * @fs_data: private data given by FS and passed to ->set_context()
>   *
>   * This should be called after fscrypt_prepare_new_inode(), generally during a
>   * filesystem transaction.  Everything here must be %GFP_NOFS-safe.
>   *
>   * Return: 0 on success, -errno on failure
>   */
>  int fscrypt_set_context(struct inode *inode, void *fs_data)
>  {
> -       struct fscrypt_info *ci = inode->i_crypt_info;
> +       struct fscrypt_inode_info *ci = inode->i_crypt_info;
>         union fscrypt_context ctx;
>         int ctxsize;
>
>         ctxsize = fscrypt_context_for_new_inode(&ctx, inode);
>         if (ctxsize < 0)
>                 return ctxsize;
>
>         /*
>          * This may be the first time the inode number is available, so do any
>          * delayed key setup that requires the inode number.
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index b528f063e8ffa..a3df96736473a 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -60,21 +60,21 @@ struct kobject;
>  struct pipe_inode_info;
>  struct poll_table_struct;
>  struct kstatfs;
>  struct vm_area_struct;
>  struct vfsmount;
>  struct cred;
>  struct swap_info_struct;
>  struct seq_file;
>  struct workqueue_struct;
>  struct iov_iter;
> -struct fscrypt_info;
> +struct fscrypt_inode_info;
>  struct fscrypt_operations;
>  struct fsverity_info;
>  struct fsverity_operations;
>  struct fs_context;
>  struct fs_parameter_spec;
>  struct fileattr;
>  struct iomap_ops;
>
>  extern void __init inode_init(void);
>  extern void __init inode_init_early(void);
> @@ -731,21 +731,21 @@ struct inode {
>         };
>
>         __u32                   i_generation;
>
>  #ifdef CONFIG_FSNOTIFY
>         __u32                   i_fsnotify_mask; /* all events this inode cares about */
>         struct fsnotify_mark_connector __rcu    *i_fsnotify_marks;
>  #endif
>
>  #ifdef CONFIG_FS_ENCRYPTION
> -       struct fscrypt_info     *i_crypt_info;
> +       struct fscrypt_inode_info       *i_crypt_info;
>  #endif
>
>  #ifdef CONFIG_FS_VERITY
>         struct fsverity_info    *i_verity_info;
>  #endif
>
>         void                    *i_private; /* fs or device private pointer */
>  } __randomize_layout;
>
>  struct timespec64 timestamp_truncate(struct timespec64 t, struct inode *inode);
> diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
> index b559e6f777070..12f9e455d569f 100644
> --- a/include/linux/fscrypt.h
> +++ b/include/linux/fscrypt.h
> @@ -24,21 +24,21 @@
>   * some of the supported modes don't support arbitrarily byte-aligned messages.
>   *
>   * Since the needed alignment is 16 bytes, most filesystems will meet this
>   * requirement naturally, as typical block sizes are powers of 2.  However, if a
>   * filesystem can generate arbitrarily byte-aligned block lengths (e.g., via
>   * compression), then it will need to pad to this alignment before encryption.
>   */
>  #define FSCRYPT_CONTENTS_ALIGNMENT 16
>
>  union fscrypt_policy;
> -struct fscrypt_info;
> +struct fscrypt_inode_info;
>  struct fs_parameter;
>  struct seq_file;
>
>  struct fscrypt_str {
>         unsigned char *name;
>         u32 len;
>  };
>
>  struct fscrypt_name {
>         const struct qstr *usr_fname;
> @@ -185,21 +185,22 @@ struct fscrypt_operations {
>          *
>          * If the filesystem can use multiple block devices (other than block
>          * devices that aren't used for encrypted file contents, such as
>          * external journal devices), and wants to support inline encryption,
>          * then it must implement this function.  Otherwise it's not needed.
>          */
>         struct block_device **(*get_devices)(struct super_block *sb,
>                                              unsigned int *num_devs);
>  };
>
> -static inline struct fscrypt_info *fscrypt_get_info(const struct inode *inode)
> +static inline struct fscrypt_inode_info *
> +fscrypt_get_inode_info(const struct inode *inode)
>  {
>         /*
>          * Pairs with the cmpxchg_release() in fscrypt_setup_encryption_info().
>          * I.e., another task may publish ->i_crypt_info concurrently, executing
>          * a RELEASE barrier.  We need to use smp_load_acquire() here to safely
>          * ACQUIRE the memory the other task published.
>          */
>         return smp_load_acquire(&inode->i_crypt_info);
>  }
>
> @@ -397,21 +398,22 @@ const char *fscrypt_get_symlink(struct inode *inode, const void *caddr,
>                                 unsigned int max_size,
>                                 struct delayed_call *done);
>  int fscrypt_symlink_getattr(const struct path *path, struct kstat *stat);
>  static inline void fscrypt_set_ops(struct super_block *sb,
>                                    const struct fscrypt_operations *s_cop)
>  {
>         sb->s_cop = s_cop;
>  }
>  #else  /* !CONFIG_FS_ENCRYPTION */
>
> -static inline struct fscrypt_info *fscrypt_get_info(const struct inode *inode)
> +static inline struct fscrypt_inode_info *
> +fscrypt_get_inode_info(const struct inode *inode)
>  {
>         return NULL;
>  }
>
>  static inline bool fscrypt_needs_contents_encryption(const struct inode *inode)
>  {
>         return false;
>  }
>
>  static inline void fscrypt_handle_d_move(struct dentry *dentry)
> @@ -875,21 +877,21 @@ static inline bool fscrypt_inode_uses_fs_layer_crypto(const struct inode *inode)
>   * fscrypt_has_encryption_key() - check whether an inode has had its key set up
>   * @inode: the inode to check
>   *
>   * Return: %true if the inode has had its encryption key set up, else %false.
>   *
>   * Usually this should be preceded by fscrypt_get_encryption_info() to try to
>   * set up the key first.
>   */
>  static inline bool fscrypt_has_encryption_key(const struct inode *inode)
>  {
> -       return fscrypt_get_info(inode) != NULL;
> +       return fscrypt_get_inode_info(inode) != NULL;
>  }
>
>  /**
>   * fscrypt_prepare_link() - prepare to link an inode into a possibly-encrypted
>   *                         directory
>   * @old_dentry: an existing dentry for the inode being linked
>   * @dir: the target directory
>   * @dentry: negative dentry for the target filename
>   *
>   * A new link can only be added to an encrypted directory if the directory's
>
> base-commit: 5b11888471806edf699316d4dcb9b426caebbef2
> --
> 2.42.0
>

Looks reasonable to me.

Reviewed-by: Neal Gompa <neal@gompa.dev>


-- 
真実はいつも一つ！/ Always, there's only one truth!
